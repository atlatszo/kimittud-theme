# -*- encoding : utf-8 -*-
# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
  # Example adding an instance variable to the frontpage controller
  # GeneralController.class_eval do
  #   def mycontroller
  #     @say_something = "Greetings friend"
  #   end
  # end
  # Example adding a new action to an existing controller
  # HelpController.class_eval do
  #   def help_out
  #   end
  # end
  ApplicationHelper.class_eval do
    def extension_state_text
      return _('Currently <strong>extension</strong> state ...')
    end
  end

  FollowupsController.class_eval do
    def set_internal_review
      @internal_review = false
    end
  end

  RequestController.class_eval do
    def select_authority
      # Check whether we force the user to sign in right at the start, or we allow her
      # to start filling the request anonymously
      if AlaveteliConfiguration.force_registration_on_new_request &&
         !authenticated?
        ask_to_login(
          web: _('To send and publish your FOI request'),
          email: _("Then you'll be allowed to send FOI requests."),
          email_subject: _('Confirm your email address')
        )
        return
      end
      unless params[:query].nil?
        params[:query]
        flash[:search_params] = params.slice(:query, :bodies, :page)
        # this line is changed to use the same SQL search as in admin pages,
        # which gives better results than xapian. To be replaced with the future
        # postgres based search system once available.
        @xapian_search = PublicBody.with_query(query, 'all')
      end
      medium_cache
    end
  end
end
