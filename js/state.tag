<state>
  <div class="pure-g">
    <div class="pure-u-1-2" if={ passphrase_entered }>
      <button class="pure-button pure-u-1
      { pure-button-disabled: this.state_index <= 0 }" onclick={ back }>
        Back
      </button>
    </div>
    <div class="pure-u-1-2" if={ passphrase_entered }>
      <button class="pure-button pure-u-1
        { pure-button-disabled: next_disabled() }" onclick={ next }>
        Next
      </button>
    </div>
  </div>

  <script>
    this.passphrase_entered = false;
    this.num_attending = 0;
    this.rsvped = false;

    this.states = [
      'passphrase',
      'rsvp',
      'song_request',
      'confirm'
    ];

    this.state_index = 0;

    riot.store.on('got_invite', function(invite) {
      if (invite.first_name) {
        this.rsvped = true;
        this.num_attending = invite.num_attending;
        this.update();
        this.next();
      }
    }.bind(this));

    riot.store.on('change_state', function(state) {
      this.state_index = this.states.indexOf(state);
      if (this.state_index < 0) {
        this.state_index = 0;
      }
      this.update();
    }.bind(this));

    riot.store.on('valid_passphrase', function(passphrase) {
      this.passphrase_entered = true;
      this.update();
    }.bind(this));

    var skip_state = function() {
      if (this.num_attending === 0 &&
        this.state_index === this.states.indexOf('song_request')) {
        return true;
      }
      return false;
    }.bind(this);

    next_disabled() {
      return (!this.rsvped && this.state_index >= this.states.indexOf('rsvp'))
        || this.state_index >= this.states.length - 1;
    }

    next() {
      if (!this.next_disabled()) {
        do {
          this.state_index++;
        } while(skip_state());
        riot.store.trigger('change_state', this.states[this.state_index]);
        this.update();
      }
    }

    next_button(e) {
      e.preventDefault();
      this.next();
    }

    back(e) {
      e.preventDefault();
      if (this.state_index > 0) {
        do {
          this.state_index--;
        } while(skip_state());
        riot.store.trigger('change_state', this.states[this.state_index]);
        this.update();
      }
    }
  </script>
</state>
