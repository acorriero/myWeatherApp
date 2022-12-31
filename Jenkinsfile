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
        stage("Pull application from repo") {
            steps {
                git branch: "main",
                url: "git@github.com:acorriero/my_tf_project.git",
                credentialsId: "github-loign"
            }
        }
        stage("Terrform Init"){
            steps {
                sh "terraform init"
            }
        }
        stage('Terraform Apply'){
            steps{
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "mylab-aws",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh 'terraform apply --auto-approve'
                    }
            }
        }
    }
}
