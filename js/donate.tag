<donate>
  <div if={ active === 'confirm' }>
    <h2> Registry Info </h2>
    <p> Your presence at our wedding party is all we ask, but if you'd like to
contribute to our honeymoon or donate to a charity in our name: </p>
    <p>
      <a href="https://www.paypal.me/CollinReynolds" target="_blank">
        Contribute to honeymoon with 
       <img src="https://www.paypalobjects.com/webstatic/paypalme/images/pp_logo_small.png"
         class="paypal-logo">
      </a>
    </p>
    <h3>Charities we support:</h3>
    <div class="charities">
      <p>
        <a href="https://act.nrdc.org/donate/one-time-gift" target="_blank">
          <img src="images/nrdc.png" class="pure-img">
        </a>
      </p>
      <p>
        <a href="https://www.weareplannedparenthood.org/onlineactions/2U7UN1iNhESWUfDs4gDPNg2" target="_blank">
          <img src="images/pp.svg" class="pure-img pp-logo">
        </a>
      </p>
    </div>
  </div>

  <script>
    riot.store.on('change_state', function(state) {
      this.active = state;
      this.update()
    }.bind(this));
  </script>
</donate>
