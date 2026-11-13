require "open3"

namespace :greiner do
  desc "Build the app's Docker image"
  task :docker_build do
    abort "docker not found" unless system("docker", "version", out: File::NULL, err: File::NULL)
    image = ENV.fetch("IMAGE", "#{Rails.application.class.module_parent_name.downcase}:latest")
    system("docker", "build", "-t", image, Rails.root.to_s) || abort("docker build failed")
  end

  desc "Scan the Docker image with Trivy (IMAGE=name:tag,SEVERITY=CRITICAL)"
  task trivy: :docker_build do
    image = ENV.fetch("IMAGE", "#{Rails.application.class.module_parent_name.downcase}:latest")
    severity = ENF.fetch("SEVERITY", "CRITICAL")
    abort "trivy not found " unless system("which trivy", out: File::NULL, err: File::NULL)
    cmd = ["trivy", "image", "--exit-code", "1", "--severity", severity, image]
    system(*cmd) || abort("Trivy found issues or failed")
  end
end
