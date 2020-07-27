class PackageManifest
  @root : Array(Github::File)

  def initialize(repository_slug : String, @relative_path = "")
    @repository = Github::Repository.new repository_slug
    @root = repository.content

    navigate_to_root
  end

  property relative_path
  private property repository
  private property root

  def navigate_to_root
    return if @relative_path == ""

    @root = Github::Content.new(@repository, @relative_path).fetch
  end

  def last_commit
    repository.commits.first
  end

  def version
    last_commit.date.gsub '-','.'
  end

  def files
    files = root
      .select {|file| file.name.ends_with?(".groovy") }
      .map {|file| Hubitat::File.from github: file }
  end

  def license_file
    root.select {|file| file.name == "LICENSE" }
      .first?
  end

  def manifest
    JSON.build do |j|
      j.object do
        package_name = [repository.author, repository.name]

        if ! relative_path.blank?
          package_name << relative_path.gsub('/','-')
        end

        j.field "packageName", package_name.join('/')

        j.field "minimumHEVersion", "2.1.9"
        j.field "author", repository.author
        j.field "version", version
        j.field "dateReleased", last_commit.date

        if license_path = license_file
          j.field "licenseFile", license_path.download_url
        end

        j.field "apps" do
          j.array do
            files.select(&.app?).each do |app|
              j.object do
                j.field "id", Digest::SHA1.hexdigest(app.name).to_s
                j.field "name", app.name
                j.field "namespace", app.namespace
                j.field "location", app.url
                j.field "required", false
                j.field "oauth", false
              end
            end
          end
        end

        j.field "drivers" do
          j.array do
            files.select(&.driver?).each do |driver|
              j.object do
                j.field "id", Digest::SHA1.digest(driver.name).to_s
                j.field "name", driver.name
                j.field "namespace", driver.namespace
                j.field "location", driver.url
                j.field "required", false
                j.field "oauth", false
              end
            end
          end
        end
      end
    end
  end
end

