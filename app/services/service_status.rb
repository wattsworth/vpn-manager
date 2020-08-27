# frozen_string_literal: true

# Handles service notices, errors and warnings. Design pattern:
# All service action should occur in the run() function
# Within run, call add_error or add_warning with string
# messages. At the end of run() return the service object itself
# For nested services, call absorb_service(child.run()) to nest
# the errors and warnings of the child into the parent, set
# the action parameter to NEVER_FAIL, FAIL_ON_WARNING, or
# FAIL_ON_ERROR to determine when (if ever), absorb_status
# returns false
# Services should set a notice message when run successfully
# eg "database updated"
#
module ServiceStatus
  attr_reader :errors, :warnings, :notices
  attr_writer :errors #errors can be set in bulk
  FAIL_ON_ERROR   = 0
  FAIL_ON_WARNING = 1
  NEVER_FAIL      = 2

  def initialize
    @errors = []
    @warnings = []
    @notices = []
  end

  def add_notice(message)
    # ignore duplicates
    return if @notices.include?(message)
    @notices << String(message)
  end

  # clear out notices, and set to current message
  def set_notice(message)
    @notices = [message]
  end

  def add_error(message)
    # ignore duplicates
    return if @errors.include?(message)
    @errors << String(message)
  end

  def add_errors(messages)
    messages.each{|m| self.add_error(m)}
  end

  def errors?
    !@errors.empty?
  end

  def add_warning(message)
    # ignore duplicates
    return if @warnings.include?(message)
    @warnings << String(message)
  end

  def add_warnings(messages)
    messages.each{|m| self.add_warning(m)}
  end

  def warnings?
    !@warnings.empty?
  end

  def success?
    !errors?
  end

  def reset_messages
    @errors = []
    @warnings = []
    @notices = []
  end

  def run
    raise 'Implement in client, return service object'
  end

  def absorb_status(service, action: FAIL_ON_ERROR)
    @notices += service.notices
    @warnings += service.warnings
    @errors += service.errors
    case action
    when FAIL_ON_WARNING
      return false if warnings? || errors?
    when FAIL_ON_ERROR
      return false if errors?
    end
    true
  end

end
