// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import UIKit

class DeviceInfo{
    var manufacturer: String {
        return "Apple"
    }

    var model: String {
        return UIDevice.current.model
    }

    var os: String {
        return UIDevice.current.systemName
    }

    var osVersion: String {
        return UIDevice.current.systemVersion
    }

    var sdkVersion: String {
        // iOS no expone el SDK version directamente como número entero,
        // se usa el mismo que systemVersion
        return UIDevice.current.systemVersion
    }

    var deviceType: String {
        // Esto no es 100% confiable, pero funciona en la mayoría de los casos
        let idiom = UIDevice.current.userInterfaceIdiom
        switch idiom {
            case .pad:
                return "Tablet"
            case .phone:
                return "Smartphone"
            default:
                return "Unknown"
        }
    }

    var language: String {
        return Locale.current.languageCode ?? "unknown"
    }

    var region: String {
        return Locale.current.regionCode ?? "unknown"
    }

    var packageName: String {
        return Bundle.main.bundleIdentifier ?? "unknown"
    }
}


open class UpinnSecretsIOS{
    // MARK: - Propiedades privadas
    private let isDebug: Bool
    private let fileName: String
    private let context: UIViewController?
    private let secrets: Secrets
    private let deviceInfo: DeviceInfo = DeviceInfo()
    private var fileBytesGlobal: [UInt8] = []
    private var fileNameGlobal: String = ""

    // MARK: - Constantes
    private static let TAG = "UpinnSecrets"

    // MARK: - Inicializador
    init(isDebug: Bool, fileName: String) {
        self.isDebug = isDebug
        self.fileName = fileName

        let dbPath = UpinnSecretsIOS.getDatabasePath(fileName: "secrets.db")
        self.secrets = Secrets(isDebug: isDebug, dbPath: dbPath)
        self.deviceInfo = DeviceInfo()

        if isDebug {
            print("[\(Self.TAG)] Call init")
        }
    }
    
    // MARK: - Función de login
    public func login() throws -> Int64{
        do {
            fileNameGlobal = fileName.replacingOccurrences(of: ".bin", with: "")
            guard let fileBytes = readFileFromBundle(fileName: fileNameGlobal) else {
                throw PluginException.errorCode(1010)
            }

            fileBytesGlobal = fileBytes

            let args = SecretsArgs(
                fileBytes: fileBytesGlobal,
                fileName: fileNameGlobal,
                packageName: deviceInfo.packageName,
                manufacturer: deviceInfo.manufacturer,
                model: deviceInfo.model,
                os: deviceInfo.os,
                osVersion: deviceInfo.osVersion,
                sdkVersion: deviceInfo.sdkVersion,
                deviceType: deviceInfo.deviceType,
                language: deviceInfo.language,
                region: deviceInfo.region,
                variable: "",
                version: ""
            )

            let resLogin = secrets.login(args: args)
            if resLogin.statusCode != 200 {
                throw PluginException.errorCode(resLogin.statusCode)
            }

            return resLogin.statusCode
        } catch let e as PluginException {
            throw e
        } catch {
            if isDebug { print("[\(Self.TAG)] \(error.localizedDescription)") }
            throw PluginException.errorCode(5000)
        }
    }

    // MARK: - Función para obtener secreto
    func getSecret(variable: String, version: String?) throws -> SecretsResponse {
        do {
            if fileBytesGlobal.isEmpty {
                throw PluginException.errorCode(1010)
            }

            let args = SecretsArgs(
                fileBytes: fileBytesGlobal,
                fileName: fileNameGlobal,
                packageName: deviceInfo.packageName,
                manufacturer: deviceInfo.manufacturer,
                model: deviceInfo.model,
                os: deviceInfo.os,
                osVersion: deviceInfo.osVersion,
                sdkVersion: deviceInfo.sdkVersion,
                deviceType: deviceInfo.deviceType,
                language: deviceInfo.language,
                region: deviceInfo.region,
                variable: variable,
                version: version ?? ""
            )

            let result = secrets.getSecret(args: args)
            if result.statusCode != 200 {
                throw PluginException.errorCode(result.statusCode)
            }

            return SecretsResponse(
                secretValue: result.secretValue,
                statusCode: result.statusCode
            )

        } catch let e as PluginException {
            throw e
        } catch {
            if isDebug { print("[\(Self.TAG)] \(error.localizedDescription)") }
            throw PluginException.errorCode(5000)
        }
    }

    // MARK: - Lectura de archivo desde bundle
    private func readFileFromBundle(fileName: String) -> [UInt8]? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "bin") else {
            if isDebug {
                print("[\(Self.TAG)] Error file \(fileName) not found in bundle")
            }
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return [UInt8](data)
        } catch {
            if isDebug {
                print("[\(Self.TAG)] Failed reading file: \(error)")
            }
            return nil
        }
    }

    // MARK: - Ruta del archivo SQLite
    private static func getDatabasePath(fileName: String) -> String {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(fileName).path
    }
}
