<passphrase>
  <div class="pure-g">
    <div class="pure-u-1" if={ !passphrase_entered }>
      <p>Enter the passphrase from your invitation:</p>
    </div>
    <form class="pure-form pure-u-1" if={ !passphrase_entered }
      onsubmit={ submit_passphrase }>
      <input type="text" class="pure-input-1" placeholder="Invite Passphrase"
        ref="passphrase" required>
      <button type="submit" class="pure-button pure-input-1 pure-button-primary">
        Enter
      </button>
    </form>
  </div>

  <script>
    submit_passphrase(e) {
      e.preventDefault();
      this.passphrase = this.refs.passphrase.value;

      riot.store.trigger('entered_passphrase', this.passphrase);

      $.get('backend/invites', {'pass_code': this.passphrase},
        function (response) {
          this.passphrase_entered = true;
          riot.store.trigger('valid_passphrase', this.passphrase);
          riot.store.trigger('got_invite', response);
          this.update();
        }.bind(this)
      );

      $.get('backend/songs', {'pass_code': this.passphrase},
        function (response) {
          riot.store.trigger('got_songs', response.tracks);
        }.bind(this)
      );
    }
  </script>
</passphrase>
