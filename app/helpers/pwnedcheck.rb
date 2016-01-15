
# checks to see if an email has been pwned.
# returns nil if safe, otherwise returns an array of hashes containing information about the breach
def check_if_pwned(email)
  begin
    breaches = PwnedCheck::check(email)
    if breaches.empty?
      return nil
    else
      return breaches
    end
  rescue PwnedCheck::InvalidEmail => e
    return nil
  end
end