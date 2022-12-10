pipeline {
    agent any

    environment {
        def DEFAULT_BUILD_NAME = "${env.JOB_BASE_NAME}_${env.BUILD_NUMBER}"
    }

    parameters {
        choice( name: "DEPLOY_ENV", choices: ["DEV", "PROD"], description: "Which environment to deploy in?")
        string(name: "DEPLOY_NAME", defaultValue: "${env.DEFAULT_BUILD_NAME}", description: "Provide the deployment name.")
        choice(name: 'RELEASE_VERSION', choices: ['one', 'two', 'three'], description: 'Select release version to deploy.')
    }

    stages {
        stage("Clean Up"){
            steps {
                dir("myWeatherApp") {
                    deleteDir()
                }
            }
        }
        stage("Pull application from repo") {
            steps {
                sh "git clone https://github.com/acorriero/myWeatherApp.git"
            }
        }
        stage("Build application"){
            steps {
                dir("myWeatherApp") {
                    sh "ls -l"
                }
            }
        }
        stage("Terrform Init"){
            steps {
                dir("myWeatherApp") {
                    sh "terraform init"
                }
            }
        }
        stage('Terraform Apply'){
            steps{
                dir("myWeatherApp") {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "ilab-aws",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                            sh 'terraform plan' // --auto-approve'
                        }
                }
            }
        }
    }
}