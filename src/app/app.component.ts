import { Component } from '@angular/core';
import { Router } from '@angular/router';
import _ from 'lodash';

import { AppService } from './app.service';
import { ConfigService } from './config/config.service';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.scss'],
})
export class AppComponent {
    public constructor(private configService: ConfigService, private service: AppService, private router: Router) {
        this.initialize();
    }

    private initialize(): void {
        if (this.configService && this.configService.isInitialized()) {
            if (this.configService.isLoaded()) {
                if (this.configService.isValid()) {
                    this.router.navigate(['/main-screen']);
                } else {
                    if (_.isEqual(this.configService.getErrors(), this.service.getUpdateError())) {
                        if (this.service.autoFixError()) {
                            this.initialize();
                        } else {
                            this.configService.setUpdate();
                            this.router.navigate(['/no-config']);
                        }
                    } else {
                        this.router.navigate(['/invalid-config']);
                    }
                }
            } else {
                this.router.navigate(['/no-config']);
            }
        } else {
            setTimeout(this.initialize.bind(this), 1000);
        }
    }
}
