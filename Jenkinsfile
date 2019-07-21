import groovy.io.FileType

@NonCPS
def getFiles(String baseDir) {
    Arrays.asList(new File(baseDir).listFiles())
}

node {
  def docker_image = docker.build("dev_container", '-f ./Dockerfile .')
  def dirs = getFiles("${env.WORKSPACE}/cases")
  
  for (int i = 0; i < dirs.size(); i++) {
    dir = dirs.get(i);
    stage (dir.name + " " + "run") {
      def badge = addEmbeddableBadgeConfiguration(id: dir.name + "build", subject: dir.name + "build");
      try {
        docker_image.inside {
          sh 'make apply-' + dir.name
          sh 'make destroy-' + dir.name
          }
        badge.setStatus('works');
      } catch (Exception err) {
        badge.setStatus('failed');
      }
    }
  }
}
