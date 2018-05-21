<rsvp>
  <form class="pure-form" if={ active === 'rsvp' }
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
      <div class="btn-group-toggle" data-toggle="buttons">
        <label class="btn pure-button { pure-button-primary:attending } { pure-button-active:attending }" onclick={ toggle_attend }>
          <input id="attending" type="radio" checked={ attending }/> Yes! I'm attending
        </label>
        <label class="btn pure-button { pure-button-primary:!attending } { pure-button-active:!attending }" onclick={ toggle_not_attend }>
          <input id="attending" type="radio" checked={ !attending }/> I am deeply saddened I cannot attend
        </label>
      </div>
      <input type="number" id="num_attending" class="pure-input-1-4"
        value={ attending ? num_attending : 0} min={ attending ? 1 : 0}
        max={ attending ? 10 : 0} ref="num_attending" disabled={ !attending }/>
      <label for="num_attending">Number Attending</label>
    </div>
    <button type="submit" class="pure-button pure-input-1 pure-button-primary">
      RSVP
    </button>
  </form>

  <script>
    this.passphrase = '';
    this.attending = true;
    this.num_attending = 1;

    riot.store.on('change_state', function(state) {
      this.active = state;
      this.update();
    }.bind(this));

    riot.store.on('got_invite', function(invite) {
      this.first_name = invite.first_name;
      this.last_name = invite.last_name;
      this.email = invite.email;
      this.num_attending = invite.num_attending === null ? 1 : invite.num_attending;
      if (invite.num_attending > 0) {
        this.attending = true;
      }
      this.update();
    }.bind(this));

    riot.store.on('valid_passphrase', function(passphrase) {
      this.passphrase = passphrase;
      this.update();
    }.bind(this));

    toggle_attend(e) {
      this.attending = true;
      if (this.num_attending <= 0) {
        this.num_attending = 1;
      }
      this.update();
    }

    toggle_not_attend(e) {
      this.attending = false;
      this.update();
    }

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
          riot.store.trigger('got_invite', response);
        }
     });
    }
  </script>
</rsvp>
