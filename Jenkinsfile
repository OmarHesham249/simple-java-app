pipeline {
    agent any

    tools {
        maven 'M3916'
    }

    stages {
        stage('1. Fetch Code') {
            steps {
                echo 'Fetching Code from GitHub...'
                git branch: 'main', url: 'https://github.com/ziadibrahim509/simple-java-app'
            }
        }

       stage('2. Build') {
            steps {
                echo 'Building Java Application using Maven...'
                withMaven(maven: 'M3916') {
                    sh 'mvn clean compile'
                }
            }
        }

        stage('3. Test') {
            steps {
                echo 'Running Unit Tests...'
                withMaven(maven: 'M3916') {
                    sh 'mvn test package'
                }
            }
        }

        stage('4. Push (Docker Image)') {
            steps {
                echo 'Building Docker Image and Pushing...'

                sh 'docker build -t haythammohamd/simple-java-app:latest .'

            }
        }

        stage('5. Deploy') {
            steps {
                echo 'Deploying Application to Production...'
                sh 'docker stop my-running-app || true'
                sh 'docker rm my-running-app || true'

                sh 'docker run -d --name my-running-app -p 8081:8080 haythammohamd/simple-java-app:latest'
                echo 'Application is live on port 8081!'
            }
        }
    }
}
