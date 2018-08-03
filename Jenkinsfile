node{
    def branches = [:]
    
    for(int i = 0; i < 2; i++) {
        int port=60000 + i
        branches["split${i}"] = {
            node {
                checkout scm
                def c = docker.build('mybuilder')
                c.inside("-u root:root -v $HOME/.m2:/root/.m2") {
                    sh 'pwd'
                    sh 'mvn spring-boot:run'
                }
            }
        }
    }
    parallel branches

}
