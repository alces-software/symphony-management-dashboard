class PieFilter < Nanoc3::Filter
  identifier :pie

  def run(content, params = {})
    content.gsub('PIE.htc','/PIE.htc')
  end
end
