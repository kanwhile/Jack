var app = angular.module('app.eng_rep_billing', []);

app.controller('EngRepBilling', function($scope, $http, Report_E, $filter, $cookieStore, Excel, $timeout) {
    //waitingDialog.show();
    // List Data
    $scope.months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    $scope.thai_months = ["มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]
    $scope.datenow = new Date();
    $scope.data_tou = [];
    $scope.list_meter = {};
    $scope.search = {
        meter_id: "",
        day_start : $scope.datenow,
        day_stop : $scope.datenow,
    };
    function GetListMetr(){
        Report_E.gettable($scope.DB1, 'eg_ms_meter').then(function(res) {
            if (res.resource !== undefined) {
                $scope.list_meter = res.resource;
            }
        })
    }
    GetListMetr();

    $scope.SearchDataBilling = function(){

        var data = [{
            "name": "PAR_METER_ID",
            "param_type": "IN",
            "value": $scope.search.meter_id
        },{
            "name": "PAR_IN_DATE_S",
            "param_type": "IN",
            "value": moment($scope.search.day_start).format('YYYYMMDD')
        },{
            "name": "PAR_IN_DATE_ST",
            "param_type": "IN",
            "value": moment($scope.search.day_stop).format('YYYYMMDD')
        }];
        Report_E.sp_param($scope.DB2, 'SP_EGELP_REPORT_GENESIS', data).then(function(res) {
            
            if (res.resource !== undefined) {
                $scope.data_unitmeter = res.resource;
            }else{
                $('#model_nodata').modal('show')
            }
        })

    }

    $scope.mmFormatTime = function(strDatetime){
        return moment(strDatetime).format('DD-MM-YYYY');
    }

    $scope.btn_print = function(par_meterid){
        $scope.panal_print = true;
        $scope.data_bill = $filter('filter')($scope.data_unitmeter,{meter_id:par_meterid})[0];
        $scope.data_bill.all_total = parseFloat($scope.data_bill.total_unit) + parseFloat($scope.data_bill.total_demand) + parseFloat($scope.data_bill.total_ft);
        console.log($scope.data_bill)
    }

    $scope.PrintBilling = function() {
        // var printContents = document.getElementById('content-billing').innerHTML;
        var content = document.getElementById('content-billing').innerHTML;
        var mywindow = window.open('', 'Print', 'height=600,width=800');

        mywindow.document.write('<html><head><title>Print</title>');
        mywindow.document.write('</head><body >');
        mywindow.document.write(content);
        mywindow.document.write('</body></html>');

        mywindow.document.close();
        mywindow.focus()
        mywindow.print();
        mywindow.close();
        return true;
    }
})
