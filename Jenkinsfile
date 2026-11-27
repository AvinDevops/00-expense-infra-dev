pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        ansiColor('Xterm')
    }
    stages {
        stage('Init') {
            steps {
                sh """
                 ls -l
                 cd 01-vpc
                 terraform init -reconfigure
                """
            }
        }
        stage('Plan') {
            steps {
                sh 'echo this is test'
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo this is deploy'
            }
        }
    }
    post {
        always {
            echo "I will run always"
            deleteDir()
        }
        success {
            echo "I will run, when it is success"
        }
        failure {
            echo "I will run, when it is failed"
        }
    }
}