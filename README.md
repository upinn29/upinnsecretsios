[![Swift](https://img.shields.io/badge/Swift-6.1+-orange)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%20-blue)]()
[![License](https://img.shields.io/github/license/upinn29/upinnsecretsios)](https://github.com/upinn29/upinnsecretsios/blob/main/LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/upinn29/upinnsecretsios?style=social)](https://github.com/upinn29/upinnsecretsios/stargazers)
[![Release](https://img.shields.io/github/v/tag/upinn29/upinnsecretsios?label=version)](https://github.com/upinn29/upinnsecretsios/releases)
[![Build Status](https://img.shields.io/github/actions/workflow/status/upinn29/upinnsecretsios/swift.yml)](https://github.com/upinn29/upinnsecretsios/actions)

iOS SPM for consuming protected secrets from the [Upinn](https://upinn.tech). It offers secure on-device authentication and retrieval of encrypted secrets.

## 🛠 Installation

### 1. Add the UpinnSecretsiOS SPM Dependency in Xcode

#### 1.  Open Your Xcode Project
- Launch Xcode and open your project (.xcodeproj or .xcworkspace).

#### 2. Add the Package Dependency
- Navigate to:
    - `File > Add Package Dependencies...` (or `File > Swift Packages > Add Package Dependency...` in older Xcode versions).

#### 3. Enter the Repository URL
- Paste the GitHub URL of UpinnSecretsiOS:
    ```bash
    https://github.com/upinn29/upinnsecretsios.git
    ```
- Click Next.

#### 4. Select Version Rules
- Choose a versioning option:
    - Branch: `main` (latest development version)
    - Version: Specify a release (e.g., `1.0.0`) or range (e.g., `Up to Next Major Version`).
- Click Next.

#### 5. Choose the Target
- Select your project’s target(s) where the package should be linked.
- Ensure "UpinnSecretsiOS" is checked under "Add to Target".
- Click Finish.
---


## 🚀 Usage

### 1. Place your `filename.bin` file in the project's `Resources` directory:
```bash
Resources/  # <-- Place file here
└── filename.bin
```

**_NOTE:_**  ⚠️ Do not rename the file. It must match the name you configure in the code.

### 2. Initialize the Class
```swift
self.secrets = try  UpinnSecretsiOSLib(
    isDebug: true,
    fileName: "filename"
)
```

### 3. Authentication (Login)
```swift
do {
    guard let code = try secrets?.login() else {
        self.secretValue = "Login retornó nulo"
        return
    }
        self.secretValue = "Login exitoso (Código: \(code))"
} catch {
    self.secretValue = "Error en login: \(error.localizedDescription)"
}
```

### 4. Get Secret

```swift
do {
    guard let res = try secrets?.getSecret(variable: "YOUR_SECRET", version: nil) else {
        self.secretValue = "Respuesta nula"
        return
    }
    if res.statusCode == 200 {
        self.secretValue = res.secretValue
    } else {
        self.secretValue = "Error: Código \(res.statusCode)"
    }
} catch {
    self.secretValue = "Error al obtener secreto: \(error.localizedDescription)"
}
```

✅ `SecretsResponse` contains:
```swift
SecretsResponse(secretValue: String, statusCode: Int64)
```

- 🧪 Error Handling
    - `login()` and `get_secret()` can throw exceptions if any network, authentication, or execution errors occur.

    - You can handle the status codes (`statusCode`) to customize responses.

- 🧰 Requirements
    - iOS 16 or higher.

## 📄 License

This software is exclusively licensed for commercial use under contract with [upinn.tech](https://upinn.tech).

Its use, modification, or redistribution is not permitted without express authorization.

🔒 To obtain a license, contact: [support@upinn.tech](mailto:contacto@upinn.tech)



🧑‍💻 Author

Developed by Upinn.tech
