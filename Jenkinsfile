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
                        sh "wget --spider -nv --tries 0 --waitretry 1 --retry-connrefused 10.33.0.100:${port}"
                        dockerimage.inside("-u root:root -v $HOME/.m2:/root/.m2") {
                        //    sh "mvn test -Dselenide.baseUrl=http://10.33.0.100:${port} -Dselenide.browser=chrome -Dremote=http://10.33.0.100:4444/wd/hub"
                        }
                        sh "curl -X POST 10.33.0.100:${port}/actuator/shutdown"
                    }
                )
            }
        }
    }
    parallel branches

}
