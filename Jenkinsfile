node{
    def branches = [:]
    
    for(int i = 0; i < 5; i++) {
        int port=60000 + i
        branches["split${i}"] = {
            node {
                checkout scm
                docker.image('maven:3.5.4-jdk-8').inside("-u root:root -v $HOME/.m2:/root/.m2") {
                    sh 'pwd'
                    sh 'mvn spring-boot:run'
                    sleep 30
                }
            }
        }
    }
    parallel branches

}
