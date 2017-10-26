module Analyzers
  module Helpers
    def cmd(cmd, env={})
      puts ' - ' + cmd
      system(env, cmd)
    end
  end
end
