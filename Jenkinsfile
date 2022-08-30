// build parameters
def OPTION_DISABLED = "disabled"
def OPTION_ENABLED = "enabled"

pipeline {
  agent { label 'WIN' }

  environment {
    // general settings
    PROJECT_VERSION = '0.1'

    PACKAGE_FOLDER = ".\\build"
    PACKAGE_NAME = 'OTR.IIS.Test-Hardening'
    PACKAGE_NUSPEC = ".\\package\\OTR.IIS.Test-Hardening.nuspec"
  
    
    // nuget settings
    REPOSITORY_NUGET_API_KEY = credentials('nuget-repo-key')
    REPOSITORY_NUGET_URL = 'https://nexus/repo/nuget'
  }

  parameters {
    
    choice(
      choices: ["$OPTION_ENABLED", "$OPTION_DISABLED"],
      description: 'Uploads downloaded packages in nuget repo',
      name: 'OPTION_NUGET_UPLOAD')
      
  }

  stages {

    stage ('init pipeline') {

      steps {
        script {
          // remove all file not under source control
          bat 'git clean -xdf'

          // build version
          env.BUILD_VERSION = "${PROJECT_VERSION}.${BUILD_NUMBER}"

          // pipeline's display name
          currentBuild.displayName = "#${BUILD_VERSION}"

          // create directories
          bat "mkdir ${PACKAGE_FOLDER}"
        }
      }
    }

    stage('Create nuget package') {
      steps {
          powershell """
             & "D:\\Program Files\\Tools\\NuGet\\nuget.exe" pack ${PACKAGE_NUSPEC} -OutputDirectory "${PACKAGE_FOLDER}" -Version "${BUILD_VERSION}"
          """
      }
    }

    stage('Nuget Upload') {
      when {
        expression { params.OPTION_NUGET_UPLOAD != "$OPTION_DISABLED" || params.OPTION_NUGET_UPLOAD != "$OPTION_DISABLED" }
      }

      environment {
        CHOCO_FILE = "${PROJECT_NAME_PACKAGES}.${BUILD_VERSION}.nupkg"
      }

    steps {
        echo "=========== Upload artifacts to ${REPOSITORY_NUGET_URL} ==========="
        powershell """ 
            \$ErrorActionPreference = "Stop" 
            
            function Push-NugetPackage {
                    param (
                        [Parameter(Mandatory = \$true)]
                        [String]\$PackageLocation,
                        [Parameter(Mandatory = \$false)]
                        [bool] \$IgnoreError = \$false,
                        [Parameter(Mandatory = \$true)]
                        [String]\$SourceRepository,
                        [Parameter(Mandatory = \$true)]
                        [String]\$ApiKey
                    )

                    process {
                        Write-Host "[INFO] nuget push `"\$PackageLocation`" to `"\$SourceRepository`""
                        & "D:\\Program Files\\Tools\\NuGet\\nuget.exe" push "\$PackageLocation" -Source "\$SourceRepository" -ApiKey \$ApiKey

                        if ((\$LASTEXITCODE -ne 0) -and (!(\$IgnoreError))) {
                            Write-Error "[ERROR] nuget push failed. ExitCode = \$LASTEXITCODE"
                            exit 1
                        }
                    }
            }

            function Upload-PackageToNugetRepository {
                param(
                    [Parameter(Mandatory = \$true)]
                    [string] \$DownloadLocation,
                    [Parameter(Mandatory = \$true)]
                    [string] \$SourceRepository,
                    [Parameter(Mandatory = \$true)]
                    [string] \$ApiKey
                )

                Write-Host "[INFO] Uploading packages in \$DownloadLocation to \$SourceRepository"
                # download nuget packages
                Get-ChildItem "\$DownloadLocation" -Filter *.nupkg -Recurse | Foreach-Object {
                    Write-Host "[INFO] Uploading \$(\$_.Name) to \$SourceRepository"
                    Write-Host(((Get-Item \$_.FullName).Length/1MB))
                    
                    Push-NugetPackage -PackageLocation "\$(\$_.FullName)" `
                        -SourceRepository \$SourceRepository `
                        -ApiKey \$ApiKey
                }
            }
            
            Upload-PackageToNugetRepository \
                                  -DownloadLocation "${PACKAGE_FOLDER}" \
                                  -SourceRepository "${REPOSITORY_NUGET_URL}" \
                                  -ApiKey ${REPOSITORY_NUGET_API_KEY}
        """
      }
    }
  }

  post { 
    always { 
      cleanWs()
    }
  }
  
}