<rsvp>
  <form class="pure-form rsvp-form" if={ passphrase_entered }
    onsubmit={ submit_rsvp }>
    <fieldset class="pure-group">
      <input type="email" class="pure-input-1" placeholder="Email"
        value={ email } ref="email" required/>
      <input type="text" class="pure-input-1" placeholder="First Name"
        value={ first_name } ref="first_name" required/>
      <input type="text" class="pure-input-1" placeholder="Last Name"
        value={ last_name } ref="last_name" required/>
    </fieldset>
    <div class="pure-control-group">
      <input type="number" id="num_attending" class="pure-input-1-4"
        value={ num_attending} ref="num_attending"/>
      <label for="num_attending">Number Attending</label>
    </div>
    <button type="submit" class="pure-button pure-input-1 pure-button-primary">
      RSVP
    </button>
  </form>

  <script>
    this.passphrase = '';

    riot.store.on('got_invite', function(invite) {
      this.first_name = invite.first_name;
      this.last_name = invite.last_name;
      this.email = invite.email;
      this.num_attending = invite.num_attending;
      this.update();
    }.bind(this));

    riot.store.on('valid_passphrase', function(passphrase) {
      this.passphrase = passphrase;
      this.passphrase_entered = true;
      this.update();
    }.bind(this));

    submit_rsvp(e) {
      e.preventDefault();
      $.ajax({
        url: 'backend/invites',
        type: 'PUT',
        contentType: "application/json",
        data: JSON.stringify({
          first_name: this.refs.first_name.value,
          last_name: this.refs.last_name.value,
          email: this.refs.email.value,
          num_attending: this.refs.num_attending.value,
          pass_code: this.passphrase
        }),
        success: function(response) {
          /* TODO: add a success message or something */
        }
     });
    }
  </script>
</rsvp>
