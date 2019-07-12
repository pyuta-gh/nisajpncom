module CommonModule
  def check_role(current_user)
    if !current_user.nil?
      if current_user.email.to_s == "mail address"
        return true
      else
        redirect_to "/404.html"
        return false
      end
    else
      redirect_to "/404.html"
      return false
    end
  end
end