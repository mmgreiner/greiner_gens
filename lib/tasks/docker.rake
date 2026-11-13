require "open3"

namespace :docker do
  image = ENV.fetch("IMAGE", "#{Rails.application.class.module_parent_name.downcase}:latest")

  desc "Build the app's Docker image"
  task :build do
    abort "docker not found" unless system("docker", "version", out: File::NULL, err: File::NULL)
    system("docker", "build", "-t", image, Rails.root.to_s) || abort("docker build failed")
  end

  desc "Scan the Docker image with Trivy (IMAGE=name:tag,SEVERITY=CRITICAL)"
  task trivy: :build do
    severity = ENV.fetch("SEVERITY", "CRITICAL")
    abort "trivy not found " unless system("which trivy", out: File::NULL, err: File::NULL)
    cmd = ["trivy", "image", "--exit-code", "1", "--severity", severity, image]
    system(*cmd) || abort("Trivy found issues or failed")
  end
end
