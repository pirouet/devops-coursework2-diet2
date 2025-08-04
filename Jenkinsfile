pipeline {

    agent any

    // Define when to check for changes
    // Based on documentation, found at:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#triggers
    triggers {
        pollSCM('H/1 * * * *')
    }

    options {
        disableConcurrentBuilds()
    }

    stages() {
        stage('Prepare') {
            steps {
                checkout scm
            }
        }
        stage('Build Image') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Test Image') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Testing..'
            }
        }
    }

    post {
        always {
            // Always clean up resources and purge images once finished
            sh 'docker builder prune -f && docker system prune -af'
        }
        success {
            steps {
                echo 'Testing..'
            }
        }
        failure {
            sh "echo 'Build failed!'"
        }

    }

}
