# -*- coding: utf-8 -*-
require 'cgi'

Plugin.create(:burnt_toast) do
  on_popup_notify do |user, text, &stop|
    icon_path(user.icon).trap{|err|
      warn err
      icon_path(Skin['notfound.png'])
    }.next{|icon_file_name|
      command = ["powershell.exe", "-command", "New-BurntToastNotification", "-Text"]
      if text.respond_to?(:description_plain)
        text = text.description_plain
      elsif text.is_a?(Diva::Model)
        text = text.to_s
      end
      if user
        command << "'#{user.title}',"
      end
      text = CGI.unescapeHTML(text).gsub(/'/) { "''" }
      command << "'#{text}'"
      if user
        win_path = wsl_path_to_windows_path(icon_file_name)
        command << "-AppLogo" << "'#{win_path}'"
      end
      pp command
      $stdout.flush
      bg_system(*command)
    }.terminate
    stop.call
  end

  def wsl_path_to_windows_path (wsl_path)
    if wsl_path.start_with?('/mnt/') && wsl_path[6] == '/'
      drv = wsl_path[5].upcase
      path = wsl_path[7..-1]
      "#{drv}:#{path}".gsub(%r|/|) do "\\" end
    else
      "#{UserConfig[:burnt_toast_rootfs_path]}#{wsl_path}".gsub(%r|/|) do "\\" end
    end
  end

  def icon_path(photo)
    ext = photo.uri.path.split('.').last || 'png'
    fn = File.join(icon_tmp_dir, Digest::MD5.hexdigest(photo.uri.to_s) + ".#{ext}")
    Delayer::Deferred.new.next{
      case
      when FileTest.exist?(fn)
        fn
      else
        photo.download_pixbuf(width: 48, height: 48).next{|p|
          FileUtils.mkdir_p(icon_tmp_dir)
          photo.pixbuf(width: 48, height: 48).save(fn, 'png')
          fn
        }
      end
    }
  end

  memoize def icon_tmp_dir
    File.join(Environment::TMPDIR, 'burnt_toast', 'icon').freeze
  end

  UserConfig[:burnt_toast_rootfs_path] ||= ''

  settings "BurntToast" do
    input 'Windows側から見たWSL rootfsの位置', :burnt_toast_rootfs_path
  end
end
