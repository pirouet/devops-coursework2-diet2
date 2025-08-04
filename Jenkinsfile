pipeline {

    agent any

    // Define when to check for changes
    // Based on documentation, found at:
    // https://www.jenkins.io/doc/book/pipeline/syntax/#triggers
    triggers {
        pollSCM('* * * * *')
    }

    options {
        disableConcurrentBuilds()
    }

    stages() {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t mpirouet/cw2-server:"$(jq -r .version package.json)" .'
            }
        }
        stage('Test Image') {
            steps {
                sh 'docker run -d --name cw2-server -p 8081:8081 mpirouet/cw2-server:"$(jq -r .version package.json)"'
                sh 'echo "$(docker exec -it cw2-server sh -c echo)"'
                sh "curl -f http://localhost:8081"
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', 'docker-hub-credentials') {
                        sh 'docker push mpirouet/cw2-server:"$(jq -r .version package.json)"'
                    }
                }

                sh 'docker push'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sshagent(credentials: ['prd-ssh-key']) {
                    sh 'ssh ubuntu@172.31.33.75'
                    sh 'kubectl set image deployments/cw2-server cw2-server=mpirouet/cw2-server:"$(jq -r .version package.json)"'
                    sh 'kubectl rollout status deployments/cw2-server'
                }
            }
        }
    }

    post {
        always {
            // Always clean up resources and purge images once finished
            sh 'docker stop cw2-server'
            sh 'docker builder prune -f && docker system prune -af'
        }
        success {
            echo 'Build and deployment successful!'
        }
        failure {
            sh "Build and Deployment Failed!"
        }

    }

}