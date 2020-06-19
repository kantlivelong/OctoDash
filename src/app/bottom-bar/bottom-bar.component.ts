import { Component, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';

import { ConfigService } from '../config/config.service';
import { PrinterService, PrinterStatusAPI } from '../printer.service';

@Component({
    selector: 'app-bottom-bar',
    templateUrl: './bottom-bar.component.html',
    styleUrls: ['./bottom-bar.component.scss'],
})
export class BottomBarComponent implements OnDestroy {
    private subscriptions: Subscription = new Subscription();
    public printer: Printer;

    public constructor(
        private printerService: PrinterService,
        private configService: ConfigService,
    ) {
        this.printer = {
            name: this.configService.getPrinterName(),
            status: 'connecting ...',
        };
        this.subscriptions.add(
            this.printerService.getObservable().subscribe((printerStatus: PrinterStatusAPI): void => {
                this.printer.status = printerStatus.status;
            }),
        );
    }

    public ngOnDestroy(): void {
        this.subscriptions.unsubscribe();
    }
}

interface Printer {
    name: string;
    status: string;
}
