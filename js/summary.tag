<summary>
  <div class="pure-u-1" if={ active === 'confirm' && num_attending > 0 }>
    <p> We're looking forward to seeing you! </p>
    <p> Attendee: { first_name } { last_name } </p>
    <p> Number attending: { num_attending } </p>
  </div>
  <div class="pure-u-1" if={ active === 'confirm' && num_attending <= 0 }>
    <p> We're sorry you can't make it! </p>
  </div>

  <script>
    riot.store.on('change_state', function(state) {
      this.active = state;
      if (state === 'confirm') {
        this.get_confirmation();
      }
      this.update()
    }.bind(this));

    riot.store.on('valid_passphrase', function(passphrase) {
      this.passphrase = passphrase;
      this.update();
    }.bind(this));

    get_confirmation() {
      $.get('backend/invites', {'pass_code': this.passphrase},
        function (response) {
          this.first_name = response.first_name;
          this.last_name = response.last_name;
          this.num_attending = response.num_attending;
          this.update();
        }.bind(this)
      );
    }
  </script>
</summary>
