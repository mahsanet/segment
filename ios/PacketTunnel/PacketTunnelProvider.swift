import NetworkExtension
import Tun2SocksKit
import os.log
import ProxyCoreKit


class PacketTunnelProvider: NEPacketTunnelProvider {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "ProxyCoreTunnel", category: "TunnelProvider")

    // Configuration defaults
    private struct TunnelDefaults {
        static let port: Int32 = 2080
        static let address = "127.0.0.1"
        static let mtu = 1500
        static let tunnelAddress = "127.0.0.1"
        static let tunnelIpv4 = "198.18.0.1"
        static let tunnelIpv4Mask = "255.255.255.0"
        static let tunnelIpv6 = "fc00::1"
        static let tunnelIpv6PrefixLength = 64
        static let dnsServers = ["1.1.1.1", "8.8.8.8"]
        static let taskStackSize = 20480
        static let tcpBufferSize = 4096
        static let connectTimeout = 5000
        static let readWriteTimeout = 60000
        static let logLevel = "error"
        static let coreName = "xray"
        static let startMode = "simple"
    }

    override func startTunnel(options: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        
        // Get configuration settings
        let config = getTunnelConfiguration(options: options)

        // Configure network settings
        let networkSettings = createNetworkSettings(
            mtu: config.mtu,
            ipv4Address: TunnelDefaults.tunnelIpv4,
            ipv6Address: TunnelDefaults.tunnelIpv6
        )

        logger.info("Applying Tunnel Network Settings...")

        setTunnelNetworkSettings(networkSettings) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.logger.error("Failed to set network settings: \(error.localizedDescription)")
                completionHandler(error)
                return
                
            }

            self.logger.info("Network settings applied successfully")

            // Start GRPC server
            let grpcStarted = self.startGRPCServer()
            if grpcStarted && config.startMode == "normal"{
                // Start Proxy Core if GRPC server started & tunnel startMode is normal
                self.startProxyCore(
                    coreName: config.coreName,
                    cacheDir: config.cacheDir,
                    proxyCoreConfig: config.proxyCoreConfig
                )
            }

            // Configure and start the Socks5 tunnel
            let tunnelConfig = self.createSocks5TunnelConfig(
                mtu: config.mtu,
                port: config.port,
                address: config.address
            )

            self.startSocks5Tunnel(config: tunnelConfig)
            self.logger.info("Tunnel Started ✅")
            completionHandler(nil)
        }
    }

    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        logger.info("Stopping ProxyCore...")
        IosStopCoreIOS()
        logger.info("Stopping VPN tunnel...")
        Tun2SocksKit.Socks5Tunnel.quit()
        logger.info("Tunnel stopped successfully")
        completionHandler()
    }
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
            guard let json = try? JSONSerialization.jsonObject(with: messageData, options: []),
                  let dict = json as? [String: String],
                  let command = dict["command"] else {
                logger.error("❌ Invalid JSON or missing command.")
                completionHandler?(nil)
                return
            }
        
            logger.debug("Received command: \(command)")

            switch command {
                
            case "SIMPLE_START_CORE":
                let coreName = dict["coreName"]
                let config = dict["config"]
                let cacheDir = dict["cacheDir"]

                self.startProxyCore(coreName: coreName, cacheDir: cacheDir, proxyCoreConfig: config)

                let response = "true"
                completionHandler?(response.data(using: .utf8))
            case "SIMPLE_STOP_CORE":
                os_log("💎 Stopping IOS Core from handle message")
                IosStopCoreIOS()
                
                os_log("💎 IOS Core from handle message Stopped..")
                let response = "true"
                completionHandler?(response.data(using: .utf8))
            
            case "IS_CORE_RUNNING":
                let isCoreRunning = IosIsCoreRunningIOS()
                let response = String(isCoreRunning)
                completionHandler?(response.data(using: .utf8))

            case "measurePing":
                let urls = dict["urls"]
                let pingResult = IosMeasurePingIOS(urls)
                if let responseData = pingResult.data(using: String.Encoding.utf8) {
                    completionHandler?(responseData)
                } else {
                    completionHandler?(nil)
                }
            case "FETCH_LOGS":
                let fetchedLogs = IosFetchLogsIOS()
                completionHandler?(fetchedLogs.data(using: .utf8))
            case "CLEAR_LOGS":
                IosClearLogsIOS()
                completionHandler?(nil)
            case "GET_VERSION":
                let version = IosGetVersionIOS()
                completionHandler?(version.data(using: .utf8))
            default:
                logger.warning("Unknown command received: \(command)")
                completionHandler?(nil)
            }
    }

    override func sleep(completionHandler: @escaping () -> Void) {
        logger.info("Tunnel going to sleep...")
        completionHandler()
    }

    override func wake() {
        logger.info("Tunnel waking up...")
    }

    /// Represents the tunnel configuration
    private struct TunnelConfiguration {
        let port: Int32
        let address: String
        let mtu: Int
        let proxyCoreConfig: String?
        let cacheDir: String?
        let coreName: String?
        let startMode: String?
    }

    /// Extract tunnel configuration from preferences and options
    private func getTunnelConfiguration(options: [String: NSObject]?) -> TunnelConfiguration {
        var port: Int32 = TunnelDefaults.port
        var address: String = TunnelDefaults.address
        var mtu: Int = TunnelDefaults.mtu
        var coreName: String = TunnelDefaults.coreName
        var tunnelMode: String = TunnelDefaults.startMode
        // Try to load from provider configuration first
        if let providerConfig = (protocolConfiguration as? NETunnelProviderProtocol)?.providerConfiguration,
           let configData = providerConfig["config"] as? Data,
           let config = try? JSONSerialization.jsonObject(with: configData) as? [String: Any] {

            if let startMode = config["startMode"] as? String {
                tunnelMode = startMode
            }
            if let configPort = config["port"] as? Int {
                port = Int32(configPort)
            }

            if let configAddress = config["address"] as? String {
                address = configAddress
            }

            if let configMtu = config["mtu"] as? Int {
                mtu = configMtu
            }
        }

        // Override with tunnel options if provided
        if let optPort = (options?["port"] as? NSNumber)?.int32Value {
            port = optPort
        }

        if let optAddress = options?["address"] as? String {
            address = optAddress
        }

        if let optMtu = (options?["mtu"] as? NSNumber)?.intValue {
            mtu = optMtu
        }
        
        if let optCoreName = options?["coreName"] as? String {
            coreName = optCoreName
        }
        
        if let optStartMode = options?["startMode"] as? String {
            tunnelMode = optStartMode
        }

        
        let proxyCoreConfig = options?["config"] as? String
        let cacheDir = options?["cacheDir"] as? String

        return TunnelConfiguration(
            port: port,
            address: address,
            mtu: mtu,
            proxyCoreConfig: proxyCoreConfig,
            cacheDir: cacheDir,
            coreName: coreName,
            startMode: tunnelMode
        )
    }

    /// Create the network settings for the tunnel
    private func createNetworkSettings(mtu: Int, ipv4Address: String, ipv6Address: String) -> NEPacketTunnelNetworkSettings {
        let networkSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: TunnelDefaults.tunnelAddress)
        networkSettings.mtu = NSNumber(value: mtu)

        // Configure IPv4 settings
        let ipv4Settings = NEIPv4Settings(addresses: [ipv4Address], subnetMasks: [TunnelDefaults.tunnelIpv4Mask])
        ipv4Settings.includedRoutes = [NEIPv4Route.default()]
        networkSettings.ipv4Settings = ipv4Settings

        // Configure IPv6 settings
        let ipv6Settings = NEIPv6Settings(addresses: [ipv6Address], networkPrefixLengths: [NSNumber(value: TunnelDefaults.tunnelIpv6PrefixLength)])
        ipv6Settings.includedRoutes = [NEIPv6Route.default()]
        networkSettings.ipv6Settings = ipv6Settings

        // Configure DNS settings
        networkSettings.dnsSettings = NEDNSSettings(servers: TunnelDefaults.dnsServers)

        return networkSettings
    }

    
    /// Create the configuration for the Socks5 tunnel
    private func createSocks5TunnelConfig(mtu: Int, port: Int32, address: String) -> String {
        return """
        tunnel:
            mtu: \(mtu)
            ipv4: \(TunnelDefaults.tunnelIpv4)
            ipv6: '\(TunnelDefaults.tunnelIpv6)'

        socks5:
            port: \(port)
            address: \(address)
            udp: 'udp'
            pipeline: true

        misc:
            task-stack-size: \(TunnelDefaults.taskStackSize)
            tcp-buffer-size: \(TunnelDefaults.tcpBufferSize)
            connect-timeout: \(TunnelDefaults.connectTimeout)
            read-write-timeout: \(TunnelDefaults.readWriteTimeout)
            log-file: stderr
            log-level: \(TunnelDefaults.logLevel)
        """
    }

    /// Start the GRPC server
    private func startGRPCServer() -> Bool {
        let grpcStarted = IosStartGRPCIOS()
        if grpcStarted {
            logger.info("GRPC Server started successfully")
            return true
        } else {
            logger.error("Failed to start GRPC Server")
            return false
        }
    }

    /// Start the Proxy Core
    private func startProxyCore(coreName: String?, cacheDir: String?, proxyCoreConfig: String?) {
        guard let cacheDir = cacheDir, let proxyCoreConfig = proxyCoreConfig else {
            logger.error("Missing cache directory or Xray configuration")
            return
        }

        let proxyCoreResult = IosStartCoreIOS(coreName, cacheDir, proxyCoreConfig, 128, true, 2080)

        if proxyCoreResult == "true" {
            logger.info("Proxy Core started successfully")
        } else {
            logger.error("Failed to start Proxy Core: \(proxyCoreResult, privacy: .public)")
        }
    }
    

    /// Start the Socks5 tunnel
    private func startSocks5Tunnel(config: String) {
        Socks5Tunnel.run(withConfig: .string(content: config)) { result in
            self.logger.info("Tunnel exit code: \(result)")
        }
    }
}
