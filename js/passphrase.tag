<passphrase>
  <div class="pure-g">
    <div class="pure-u-1" if={ active === 'passphrase' }>
      <p>Enter the passphrase from your invitation:</p>
    </div>
    <form class="pure-form pure-u-1" if={ active === 'passphrase' }
      onsubmit={ submit_passphrase }>
      <input type="text" class="pure-input-1" placeholder="Invite Passphrase"
        ref="passphrase" value={ passphrase } required>
      <button type="submit" class="pure-button pure-input-1 pure-button-primary">
        Enter
      </button>
    </form>
    <div class="pure-u-1 alert alert-danger" if={ error_message }>
      { error_message }
    </div>
  </div>

  <script>
    this.active = 'passphrase';

    riot.store.on('change_state', function(state) {
      this.active = state;
      this.update()
    }.bind(this));

    submit_passphrase(e) {
      e.preventDefault();
      this.passphrase = this.refs.passphrase.value;
      this.error_message = null;

      $.get('backend/invites', {'pass_code': this.passphrase},
        function (response) {
          riot.store.trigger('valid_passphrase', this.passphrase);
          riot.store.trigger('got_invite', response);
          riot.store.trigger('change_state', 'rsvp');
          this.update();
        }.bind(this)
      )
      .fail(function(response) {
        this.error_message = response.responseJSON.title;
        console.log(response.responseJSON.title);
        this.update();
      }.bind(this));

      $.get('backend/songs', {'pass_code': this.passphrase},
        function (response) {
          riot.store.trigger('got_songs', response.tracks);
        }.bind(this)
      );
    }
  </script>
</passphrase>
