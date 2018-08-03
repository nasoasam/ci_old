node{
    def branches = [:]
    def c = [:]
    def dockerimage
    checkout scm
    dockerimage = docker.build('mybuilder')
    for(int i = 0; i < 2; i++) {
        int port=60000 + i
        branches["split${i}"] = {
            node {
                checkout scm
                parallel (
                    spring : {
                        dockerimage.inside("-u root:root -v $HOME/.m2:/root/.m2 -p ${port}:8080") {
                            sh "mvn spring-boot:run"
                        }
                    },
                    selenium : {
                        docker.image("centos").inside("-u root:root") {
                        sleep 60
                        sh "curl 10.33.0.100:${port}"
                    }
                )
            }
        }
    }
    parallel branches

}
