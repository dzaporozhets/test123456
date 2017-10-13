module Analyzers
  module Helpers
    def cmd(cmd)
      puts ' - ' + cmd
      system(cmd)
    end
  end
end
