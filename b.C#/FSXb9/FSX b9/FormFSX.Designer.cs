namespace FSX_b9
{
    partial class FormFSX
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormFSX));
            this.btnFSXState = new System.Windows.Forms.Button();
            this.btnSave = new System.Windows.Forms.Button();
            this.btnLoad = new System.Windows.Forms.Button();
            this.btnPushback = new System.Windows.Forms.Button();
            this.btnPushR = new System.Windows.Forms.Button();
            this.btnPushL = new System.Windows.Forms.Button();
            this.lblOverspeed = new System.Windows.Forms.Label();
            this.lblATC = new System.Windows.Forms.Label();
            this.lblFuelLow = new System.Windows.Forms.Label();
            this.lblStatus = new System.Windows.Forms.Label();
            this.btnStart = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnFSXState
            // 
            this.btnFSXState.Location = new System.Drawing.Point(12, 12);
            this.btnFSXState.Name = "btnFSXState";
            this.btnFSXState.Size = new System.Drawing.Size(139, 33);
            this.btnFSXState.TabIndex = 0;
            this.btnFSXState.Text = "btnFSXState";
            this.btnFSXState.UseVisualStyleBackColor = true;
            this.btnFSXState.Click += new System.EventHandler(this.btnFSXState_Click);
            // 
            // btnSave
            // 
            this.btnSave.Enabled = false;
            this.btnSave.Location = new System.Drawing.Point(173, 12);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(69, 33);
            this.btnSave.TabIndex = 1;
            this.btnSave.Text = "save";
            this.btnSave.UseVisualStyleBackColor = true;
            // 
            // btnLoad
            // 
            this.btnLoad.Enabled = false;
            this.btnLoad.Location = new System.Drawing.Point(248, 12);
            this.btnLoad.Name = "btnLoad";
            this.btnLoad.Size = new System.Drawing.Size(69, 33);
            this.btnLoad.TabIndex = 2;
            this.btnLoad.Text = "load";
            this.btnLoad.UseVisualStyleBackColor = true;
            // 
            // btnPushback
            // 
            this.btnPushback.Location = new System.Drawing.Point(173, 51);
            this.btnPushback.Name = "btnPushback";
            this.btnPushback.Size = new System.Drawing.Size(144, 33);
            this.btnPushback.TabIndex = 3;
            this.btnPushback.Text = "Pushback";
            this.btnPushback.UseVisualStyleBackColor = true;
            this.btnPushback.Click += new System.EventHandler(this.btnPushback_Click);
            // 
            // btnPushR
            // 
            this.btnPushR.Location = new System.Drawing.Point(248, 90);
            this.btnPushR.Name = "btnPushR";
            this.btnPushR.Size = new System.Drawing.Size(69, 33);
            this.btnPushR.TabIndex = 6;
            this.btnPushR.Text = "right";
            this.btnPushR.UseVisualStyleBackColor = true;
            this.btnPushR.Click += new System.EventHandler(this.btnPushR_Click);
            // 
            // btnPushL
            // 
            this.btnPushL.Location = new System.Drawing.Point(173, 90);
            this.btnPushL.Name = "btnPushL";
            this.btnPushL.Size = new System.Drawing.Size(69, 33);
            this.btnPushL.TabIndex = 5;
            this.btnPushL.Text = "left";
            this.btnPushL.UseVisualStyleBackColor = true;
            this.btnPushL.Click += new System.EventHandler(this.btnPushL_Click);
            // 
            // lblOverspeed
            // 
            this.lblOverspeed.AutoSize = true;
            this.lblOverspeed.Location = new System.Drawing.Point(17, 58);
            this.lblOverspeed.Name = "lblOverspeed";
            this.lblOverspeed.Size = new System.Drawing.Size(59, 13);
            this.lblOverspeed.TabIndex = 7;
            this.lblOverspeed.Text = "Overspeed";
            // 
            // lblATC
            // 
            this.lblATC.AutoSize = true;
            this.lblATC.Location = new System.Drawing.Point(92, 58);
            this.lblATC.Name = "lblATC";
            this.lblATC.Size = new System.Drawing.Size(28, 13);
            this.lblATC.TabIndex = 8;
            this.lblATC.Text = "ATC";
            // 
            // lblFuelLow
            // 
            this.lblFuelLow.AutoSize = true;
            this.lblFuelLow.Location = new System.Drawing.Point(17, 84);
            this.lblFuelLow.Name = "lblFuelLow";
            this.lblFuelLow.Size = new System.Drawing.Size(50, 13);
            this.lblFuelLow.TabIndex = 9;
            this.lblFuelLow.Text = "Fuel Low";
            // 
            // lblStatus
            // 
            this.lblStatus.AutoSize = true;
            this.lblStatus.Location = new System.Drawing.Point(17, 110);
            this.lblStatus.Name = "lblStatus";
            this.lblStatus.Size = new System.Drawing.Size(92, 13);
            this.lblStatus.TabIndex = 10;
            this.lblStatus.Text = "Connection status";
            this.lblStatus.Click += new System.EventHandler(this.lblStatus_Click);
            // 
            // btnStart
            // 
            this.btnStart.Location = new System.Drawing.Point(20, 161);
            this.btnStart.Name = "btnStart";
            this.btnStart.Size = new System.Drawing.Size(191, 24);
            this.btnStart.TabIndex = 11;
            this.btnStart.Text = "Connect to FSUIPC";
            this.btnStart.UseVisualStyleBackColor = true;
            this.btnStart.Click += new System.EventHandler(this.btnStart_Click);
            // 
            // FormFSX
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(330, 216);
            this.Controls.Add(this.btnStart);
            this.Controls.Add(this.lblStatus);
            this.Controls.Add(this.lblFuelLow);
            this.Controls.Add(this.lblATC);
            this.Controls.Add(this.lblOverspeed);
            this.Controls.Add(this.btnPushR);
            this.Controls.Add(this.btnPushL);
            this.Controls.Add(this.btnPushback);
            this.Controls.Add(this.btnLoad);
            this.Controls.Add(this.btnSave);
            this.Controls.Add(this.btnFSXState);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "FormFSX";
            this.Text = "FSX b9";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnFSXState;
        private System.Windows.Forms.Button btnSave;
        private System.Windows.Forms.Button btnLoad;
        private System.Windows.Forms.Button btnPushback;
        private System.Windows.Forms.Button btnPushL;
        private System.Windows.Forms.Button btnPushR;

        private System.Windows.Forms.Label lblOverspeed;
        private System.Windows.Forms.Label lblATC;
        private System.Windows.Forms.Label lblFuelLow;
        private System.Windows.Forms.Label lblStatus;
        private System.Windows.Forms.Button btnStart;
    }
}

