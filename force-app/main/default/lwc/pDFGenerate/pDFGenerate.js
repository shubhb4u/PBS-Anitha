import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent} from 'lightning/platformShowToastEvent';
//import uploadCSVFile from '@salesforce/apex/uploadCSVDataClass.uploadCSVDatamethod'
//import uploadFile from '@salesforce/apex/FileUploaderClass.uploadFile'
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';

export default class PDFGenerate extends LightningElement {


fileData
fileDatalist=[];
@track filesSize = 0;
@track isLoading = false;
@track FilesizeErrorMessage;
@track fileBase64;

connectedCallback() {
    // Get the current URL
    const url = window.location.href;
    console.log('URL-------------> '+url);
  }

openfileUpload(event) {
try {

var files = JSON.stringify(event.target.files[0]);
console.log("files: " + event.target.files[0]);
console.log("filedata: " + event.target.files[0].name);
console.log("files length: " + event.target.files.length);
this.fileDatalist=[];

this.filesSize=0;
for (let i = 0; i < event.target.files.length; i++) {
    const file = event.target.files[i];
    var reader = new FileReader();

    reader.onload = ((file) => {
    return (event) => {
        var reader1 = JSON.stringify(event.target.result);
        console.log("reader" + i + " " + reader1);
        if (event.target.result) {
        var base64 = event.target.result.split(',')[1];
        this.fileBase64=base64;
        console.log('this.fileBase64:'+this.fileBase64);
        let fileType = file.name.split('.').pop();
console.log('fileType:'+fileType);
        console.log(base64.length);
        this.filesSize=this.filesSize+base64.length;
        console.log(" all Filessize:"+ this.filesSize);
        if(this.filesSize>2000000){
            this.FilesizeErrorMessage = 'The file sizes should not be more than 2 mb';
        }else{
            this.FilesizeErrorMessage = '';
        }
        this.fileData = {
            'filename': file.name,
            'base64': base64
        };
        this.fileDatalist.push(this.fileData);
        }
    };
    })(file);

    reader.readAsDataURL(file);
}
} catch (error) {
console.error("Error uploading files:", error);
}

}

handleClick() {
    console.log("size of total files1: "+this.filesSize);
    console.log("size of total files1: "+this.fileDatalist.length!=0);
    if(this.filesSize<=2000000 && this.fileDatalist.length!=0){        
        this.FilesizeErrorMessage ='';
        this.isLoading = true;
        console.log('In Handle Click this.fileBase64:'+this.fileBase64);
        /*uploadCSVFile({File:this.fileBase64}).then(result1 => {
            
            console.log('result: '+result1);
            console.log('result1: '+typeof result1);
            if(result1 == null ||  result1 == ''){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'File Uploaded Successfully',
                        variant: 'Success'
                    }),
                    );
            }else{
                const customDuration = 100000;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: result1,
                        variant: 'Warning',
                        Mode:'sticky'
                    }),
                    );
                    setTimeout(() => {
                        this.closeToast();
                    }, 1000);

            }
            
                this.fileData='';
                this.fileDatalist=[];
                this.dispatchEvent(new CloseActionScreenEvent());
                this.isLoading = false;
                
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Opportunity',
                        actionName: 'list'
                    }
                });
        }).catch(error=>{
            var errorString= JSON.stringify(error);
            console.log('error message message====>' + errorString);
            this.isLoading = false;
        })*/

    //add more field here 
            console.log('fileDatalist====>' + this.fileDatalist.length);
                
    console.log('*** end createRecord *** '); 
    
}else{
    console.log('Inside else:');
    if(this.filesSize>2000000){
        this.FilesizeErrorMessage = 'The file sizes should not be more than 2 mb';
        this.fileDatalist=[];
    }else if(this.fileDatalist.length==0){
        this.FilesizeErrorMessage = 'Please Upload a file before clicking on the submit button';
    }
    else{
        this.FilesizeErrorMessage = '';
    }

    console.log('Inside else loop1');
}
}
closeAction(){
    this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            objectApiName: 'Opportunity',
            actionName: 'list'
        }
    });
    }
}