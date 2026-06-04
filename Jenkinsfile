pipeline {
    agent any

    tools {
        maven 'M3916'
    }

    environment {
        NEXUS_REGISTRY = "<NEXUS_IP>:8082"          // ← غيّر دي
        IMAGE_NAME     = "simple-java-app"
        IMAGE_TAG      = "${env.BUILD_NUMBER}"
        FULL_IMAGE     = "${NEXUS_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
        timeout(time: 20, unit: 'MINUTES')
    }

    stages {

        stage('1. Fetch Code') {
            steps {
                echo 'Fetching Code from GitHub...'
                git branch: 'main', url: 'https://github.com/OmarHesham249/simple-java-app'
            }
        }

        stage('2. Build') {
            steps {
                echo 'Building Java Application using Maven...'
                sh 'mvn clean compile'
            }
        }

        stage('3. Test') {
            steps {
                echo 'Running Unit Tests...'
                sh 'mvn test'
            }
            post {
                always {
                    // بنحفظ نتايج الـtests في Jenkins UI
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('4. Package') {
            steps {
                echo 'Packaging JAR...'
                sh 'mvn package -DskipTests'
                // بنتأكد إن الـJAR اتعمل
                sh 'ls -lh target/*.jar'
            }
        }

        stage('5. Build Docker Image') {
            steps {
                echo 'Building Docker Image...'
                sh """
                    docker build \
                        --label "build.number=${env.BUILD_NUMBER}" \
                        --label "git.commit=${env.GIT_COMMIT?.take(7)}" \
                        -t ${FULL_IMAGE} \
                        -t ${NEXUS_REGISTRY}/${IMAGE_NAME}:latest \
                        .
                """
                echo "🐳 Image ready: ${FULL_IMAGE}"
            }
        }

        stage('6. Push to Nexus') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'nexus-docker-creds',
                    usernameVariable: 'NEXUS_USER',
                    passwordVariable: 'NEXUS_PASS'
                )]) {
                    sh """
                        echo "${NEXUS_PASS}" | \
                            docker login ${NEXUS_REGISTRY} \
                            -u ${NEXUS_USER} \
                            --password-stdin

                        docker push ${FULL_IMAGE}
                        docker push ${NEXUS_REGISTRY}/${IMAGE_NAME}:latest

                        echo "🚀 Pushed: ${FULL_IMAGE}"
                    """
                }
            }
        }

        stage('7. Deploy') {
            steps {
                sh 'docker stop my-running-app || true'
                sh 'docker rm   my-running-app || true'
                sh """
                    docker run -d \
                        --name my-running-app \
                        --restart unless-stopped \
                        -p 8081:8080 \
                        ${FULL_IMAGE}
                """
                echo '✅ Application is live on port 8081!'
            }
        }
    }

    post {
        always {
            sh """
                docker rmi ${FULL_IMAGE} || true
                docker rmi ${NEXUS_REGISTRY}/${IMAGE_NAME}:latest || true
                docker logout ${NEXUS_REGISTRY} || true
            """
            echo '🧹 Cleanup done'
        }
        success { echo "✅ Build #${env.BUILD_NUMBER} succeeded" }
        failure { echo "❌ Build #${env.BUILD_NUMBER} failed — check logs" }
    }
}
