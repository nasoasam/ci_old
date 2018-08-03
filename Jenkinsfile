node{
    def branches = [:]
    
    for(int i = 0; i < 1; i++) {
        int port=60000 + i
        branches["split${i}"] = {
            node {
                docker.image('maven:3.5.4-jdk-8').inside("-v $HOME/.m2:/root/.m2") {
                    sh 'mvn spring-boot:run'
                    sleep 30
                }
            }
        }
    }
    parallel branches

}
