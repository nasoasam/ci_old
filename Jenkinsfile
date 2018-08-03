pipeline {
    agent none
    stages {
        stage('para'){
            parallel {
                stage('Back-end') {
                    agent {
                        docker { image 'maven:3-alpine' }
                    }
                    steps {

                        sh 'mvn --version'
                        sh 'mvn spring-boot:run'
                    }
                }
                stage('Front-end') {
                    agent {
                        docker { image 'node:7-alpine' }
                    }
                    steps {
                        input "次に進んでよいですか?"
                        sh 'node --version'
                    }
                }
            }
        }
    }
}
