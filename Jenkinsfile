node{
    def branches = [:]
    def c = [:]
    for(int i = 0; i < 2; i++) {
        int port=60000 + i
        branches["split${i}"] = {
            node {
                checkout scm
                c["${port}"] = docker.build('mybuilder')
                echo c["${port}"]
                c["${port}"].inside("-u root:root -v $HOME/.m2:/root/.m2 -p ${port}:8080") {
                    sh 'mvn spring-boot:run'
                }
            }
        }
    }
    parallel branches

}
