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
                        dockerimage.withRun("-u root:root -v $HOME/.m2:/root/.m2 -p ${port}:8080","mvn spring-boot:run") {cc -> {
                        c["${port}"] = cc
                        print c["${port}"].id
                        //sh "docker exec ${cc.id} mvn spring-boot:run"
                            sleep 100
                        }
                    },
                    selenium : {
                        sleep 60
                        print "---"
                        print c["${port}"].id
                        print "==="
                        c["${port}"].stop()
                    }
                )
            }
        }
    }
    parallel branches

}
