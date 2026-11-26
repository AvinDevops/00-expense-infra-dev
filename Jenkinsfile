pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }
    stages {
        stage('Init') {
            steps {
                sh """
                 ls -lt
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
        }
        success {
            echo "I will run, when it is success"
        }
        failure {
            echo "I will run, when it is failed"
        }
    }
}