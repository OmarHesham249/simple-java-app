pipeline {
    agent any

    tools {
        // نسخة المافن اللي متظبطة في جينكينز
        maven 'M3916'
    }

    stages {
        stage('1. Fetch Code') {
            steps {
                echo 'Fetching Code from GitHub...'
                // سحب كودك من الريبو الصح
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
                echo 'Running Unit Tests and Packaging...'
                sh 'mvn test package'
            }
        }

        stage('4. Push (Docker Image)') {
            steps {
                echo 'Building Docker Image and Pushing to Docker Hub...'
                
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    
                    echo 'Building Docker Image...'
                    // استخدمنا سنجل كوتس بره عشان نخلي الـ Linux ينفذ المتغيرات بنفسه
                    sh 'docker build -t $USERNAME/simple-java-app:latest .'
                    
                    echo 'Logging into Docker Hub...'
                    // الحل القاطع لإيرور الـ مالفورميد: تمرير الباسورد كـ Env Variable محمي
                    sh 'echo "$PASSWORD" | docker login -u $USERNAME --password-stdin'
                    
                    echo 'Pushing Image to Docker Hub...'
                    sh 'docker push $USERNAME/simple-java-app:latest'
                }
            }
        }

        stage('5. Deploy') {
            steps {
                echo 'Deploying Application to Production...'
                // تنظيف الكونتينرات القديمة منعاً لقفش البورتات
                sh 'docker stop my-running-app || true'
                sh 'docker rm my-running-app || true'

                echo 'Starting the new container...'
                // تشغيل الأبلكيشن من الإيميج بتاعتك اللي اتعملها بوش فوق
                sh 'docker run -d --name my-running-app -p 8081:8080 omarhesham249/simple-java-app:latest'
                
                echo '✅ Success! Application is live on port 8081!'
            }
        }
    }
}
