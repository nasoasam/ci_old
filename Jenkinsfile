node{
    def branches = [:]
    
    for(int i = 0; i < 2; i++) {
        int port=60000 + i
        branches["split${i}"] = {
            node {
                checkout scm
                def spring = docker.image('maven:3.5.4-jdk-8').run("-u root:root -v $HOME/.m2:/root/.m2")
                spring.stop()
                spring.inside() {
                    sh 'pwd'
                    sh 'mvn spring-boot:run'
                }
            }
        }
    }
    parallel branches

}
