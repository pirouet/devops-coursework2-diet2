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

    parameters {

    }

    stages() {
        stage('Prepare') {
        }
        stage('Build Image') {
        }
        stage('Test Image') {
        }
        stage('Push to Docker Hub') {
        }
        stage('Deploy to Kubernetes') {
        }
    }

    post {
        always {
            // Always clean up resources and purge images once finished
            sh 'docker builder prune -f && docker system prune -af'
        }
        success {
        }
        failure {
        }

    }

}
