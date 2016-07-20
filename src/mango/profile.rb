require 'pathname'
require 'json'
require_relative 'document'

class Profile

  def initialize path
    @path = path
    @schema = JSON.parse(File.read("#{@path}/schema.json"))
  end

  def all
    profiles =  []
    each_profile(){|profile, root, dir|
      profile["dir"] = absolute_path dir;
      profiles.push(profile);
    }
    profiles
  end

  def find name
    each_profile(){|profile_json, profile_root|
      if(profile_json["name"] == name)
        result = {}
        result["name"]        = profile_json["name"]
        result["description"] = profile_json["description"]
        @schema["files"].each{|file|
          result[file["name"]] = Document.new(profile_root, file['path'])
        }
        return result
      end
    }
    nil
  end

  def updateAllFiles(fileName, content)
    each_profile(){|profile, profile_root|
      path = @schema["files"].select{|file| file["name"] == fileName}[0]["path"]
      document = Document.new(profile_root, path)
      document.content = content;
      document.save;
    }
  end

  def each_profile
    Dir["#{@path}/*/"].each{ |profile|
      profile_json = "#{profile}profile.json"
      profile_root = "#{profile_json.sub("profile.json", "").strip()}"
      if Pathname.new(profile_json).exist?
        profile_json_contents = JSON.parse(File.read(profile_json))
        yield(profile_json_contents, profile_root, profile)
      end
    }
  end

  def absolute_path path
    return Pathname.new(path).realpath.to_s
  end

end

