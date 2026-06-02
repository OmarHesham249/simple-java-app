pipeline {
    agent {
        label 'aws-agent' // أو agent any حسب السيرفر بتاعك
    }
    
    tools {
        maven 'M3916'
    }

    stages {
        // شيلنا مرحلة الـ Fetch Code خالص عشان ما تبوظش الكود بتاعك

        stage('1. Build') {
            steps {
                echo 'Building Java Application using Maven...'
                sh 'mvn clean compile'
                // السطر ده هيشتغل على الـ pom.xml المعدل بتاعك أنت
            }
        }

        stage('2. Test') {
            steps {
                echo 'Running Unit Tests...'
                sh 'mvn test package'
            }
        }

        stage('3. Push (Docker Image)') {
            steps {
                echo 'Building Docker Image...'
                // غيرتلك الاسم هنا لـ omar عشان يبقى اليوزر بتاعك صح
                sh 'docker build -t omar/simple-java-app:latest .'
            }
        }

        stage('4. Deploy') {
            steps {
                echo 'Deploying Application...'
                sh 'docker stop my-running-app || true'
                sh 'docker rm my-running-app || true'
                sh 'docker run -d --name my-running-app -p 8081:8080 omar/simple-java-app:latest'
                echo 'Application is live on port 8081!'
            }
        }
    }
}
