# Generic structure for any security issue found by analyzer
class Issue
  attr_accessor :tool, :fingerprint, :message, :url,
                :cve, :file, :line, :priority, :solution

  def to_hash
    hash = {}

    instance_variables.each do |var|
      hash[var.to_s.delete('@')] = instance_variable_get(var)
    end

    hash
  end
end
