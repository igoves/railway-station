Vue.component('vue2-datepicker');

NProgress.configure();
axios.interceptors.request.use(config => {
    NProgress.start()
    return config
})
axios.interceptors.response.use(response => {
    NProgress.done()
    return response
})

Vue.component('modal', {
    // props: ['departure_date'],
    data() {
        return {
            data: this.$root.$data.data,
            departure_date: this.$root.$data.departure_date,
            cart: this.$root.$data.cart,
            fields: {},
            errors: {},
        }
    },
    methods: {
        submit() {
            console.log(1111111);

            axios.post('/api', {api: 'order', fields: this.fields, cart: this.cart})
            .then(function (response) {
                console.log(response.data);
                // window.document.getElementsByClassName('modal-content')[0].innerHTML = '<div class="text-center p-5"><h1 >' + Vue.prototype.message.order_success + '</h1> <a class="btn btn-success" style="text-decoration:none" href="">' + Vue.prototype.message.back + '</a><br/><br/></div>';

                this.$root.$data.showModalCart = false;

            })
            .catch(function (error) {
                console.log(error);
            });

        },
        mysqlDate(date) {
            date = date || new Date();
            return date.toISOString().split('T')[0];
        },
        getNameTrain (wagon_id) {
            return this.data.trains[this.data.wagons[wagon_id].train_id].name
        },
        getNameWagon (wagon_id) {
            return this.data.wagons[wagon_id].name
        },
        getNameWagonKlass (wagon_id) {
            return this.data.wagon_klasses[this.data.wagons[wagon_id].wagon_klass_id].name
        },
        deleteSeat(seat_id, wagon_id) {
            // console.log(seat_id, wagon_id);

            function filterFuncByObj(filterObj) {
                return function(obj) {
                    for (var p in filterObj) {
                        if (obj[p] !== filterObj[p]) return true
                    }
                    return false
                }
            }
            this.cart = this.cart.filter(filterFuncByObj({seat_id: seat_id, wagon_id: wagon_id}));
            this.$root.$data.cart = this.cart;

            // console.log(this.cart);
        },
    },
    template: `
      <div>
      <div class="modal-mask">
        <div class="modal-wrapper">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Booking {{ mysqlDate(departure_date) }}</h5>
                <button type="button" class="close" @click="$emit('close')" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body" id="checkBooking">
                <div v-for="item in cart" class="mb-2 alert alert-info">
                    <b>{{ getNameTrain(item.wagon_id) }}</b> -  
                    wagon {{ getNameWagon(item.wagon_id) }} {{ getNameWagonKlass(item.wagon_id) }},
                    place {{ data.wagon_seats[item.wagon_id][item.seat_id].name }}
                    <button @click="deleteSeat(item.seat_id, item.wagon_id)" type="button" class="btn btn-sm btn-outline-danger float-end">delete</button>
        
                    <!--
                    Seat_id: {{ item.seat_id }}<br/>
                    Wagon_id: {{ item.wagon_id }}<br/>
                    -->
                </div>

                <form class="row" @submit.prevent="submit" v-if="cart.length > 0">
                  <div class="col-4">
                    <label>Login</label>
                    <input type="text" v-model="fields.login" class="form-control" required/>
                  </div>
                  <div class="col-4">
                    <label>Password</label>
                    <input type="text" v-model="fields.password" class="form-control"
                           required/>
                  </div>
                  <div class="col-4">
                    <label>First Name</label>
                    <input type="text" v-model="fields.first_name" class="form-control" required/>
                  </div>
                  <div class="col-4">
                    <label>Last Name</label>
                    <input type="text" v-model="fields.last_name" class="form-control"
                           required/>
                  </div> 
                  <div class="col-4">
                    <label>Passport</label>
                    <input type="text" v-model="fields.passport" class="form-control"
                           required/>
                  </div>              
                  <div class="col-4 d-grid gap-0">
                    <label>&nbsp;</label>
                    <button class="btn btn-primary" type="submit">Send Order</button>
                  </div>
                </form>
                <div class="alert alert-info mb-0" v-else >
                    Please choose the place!
                </div>
                <div id="check_result"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
      </div>`
});

new Vue({
    el: '#app',
    data() {
        return {
            data: {},
            departure_date: new Date(),
            departure_time: new Date(),
            city_from: 'Kyiv',
            city_to: 'Jmerinka',
            nothing_found: null,
            search_result: null,
            searching: false,
            auth: false,
            search_trains: null,
            search_found: 0,
            selectedWagon: null,
            cart: [],
            showModalCart: false,
        }
    },
    mounted() {

        axios
            .get('/api')
            .then(response => (this.data = response.data));

    },
    methods: {
        totalAvailableWagons(wagons) {
            const findDone = Object.keys(wagons).map(t => {
                return wagons[t].status == 1;
            });
            return [].concat(...findDone).length;
        },
        totalAvailableSeats(seats) {
            const findDone = Object.keys(seats).map(t => {
                return seats[t].status == 1;
            });
            return [].concat(...findDone).length;
        },
        toggleDirectionList(index) {
            let el = document.getElementById('train_' + index);
            el.classList.toggle("d-none");
        },
        mysqlDate(date) {
            date = date || new Date();
            return date.toISOString().split('T')[0];
        },
        changeFromTo() {
            let from = this.city_from
            this.city_from = this.city_to
            this.city_to = from
        },
        searchTrain() {
            this.searching = true;

            axios
                .post('/api', {
                    api: 'search',
                    data: {
                        city_from: this.city_from,
                        city_to: this.city_to,
                        departure_date: this.departure_date,
                        departure_time: this.departure_time,
                    }
                }).then(response => {
                    // console.log(response.data.search_trains);
                    this.searching = false;
                    this.search_result = true;
                    this.data = response.data;
                    this.search_found = Object.keys(this.data.search_trains).length;
                    // if (this.search_found === 0) {
                    //     this.nothing_found = true;
                    // }
                })
                .catch(error => console.log(error));

        },
        setWagon(wagon_id) {
            this.selectedWagon = wagon_id;

            let el_all_wagon = document.getElementsByClassName('wagon');
            for(var i = 0, all = el_all_wagon.length; i < all; i++){
                el_all_wagon[i].classList.remove('border-primary');
            }

            let el_all_seats = document.getElementsByClassName('wagon_seats');
            for(var i = 0, all = el_all_seats.length; i < all; i++){
                el_all_seats[i].classList.add('d-none');
            }

            let el = document.getElementById('wagon_' + wagon_id);
            el.classList.toggle("border-primary");

            let el_seats = document.getElementById('wagon_seats_' + wagon_id);
            el_seats.classList.toggle("d-none");

            // console.log(event.currentTarget);
            // this.showModalWagon = true;

        },
        setSeat(seat_id, wagon_id) {
            // console.log(seat_id, wagon_id);

            function filterFuncByObj(filterObj) {
                return function(obj) {
                    for (var p in filterObj) {
                        if (obj[p] !== filterObj[p]) return false
                    }
                    return true
                }
            }
            var findData = this.cart.filter(filterFuncByObj({seat_id: seat_id, wagon_id: wagon_id}));
            // console.log(findData.length);

            if ( findData.length === 0 ) {
                this.cart.push({seat_id: seat_id, wagon_id: wagon_id});
            }

            this.showModalCart = true;
        },
        needTodo() {
            alert('Sorry this functional not ready! Try later :)');
        },
    },
});
