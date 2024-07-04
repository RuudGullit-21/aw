#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОшибкиПриФормированииДокументов = ПолучитьИзВременногоХранилища(Параметры.АдресСведенийОбОшибках);
	ЭлектронныйДокумент = ОшибкиПриФормированииДокументов[0].ОшибкаФормированияВПрикладнойЧасти.ЭлектронныйДокумент;
	Покупатель = ЭлектронныйДокумент.Организация;
	СоставительДокумента = Покупатель;
	Элементы.СоставительДокументаДоверенность.Видимость = Ложь;
	
	Данные = ОбменСКонтрагентами.ДанныеЭлектронногоДокумента(ЭлектронныйДокумент);
	ДеревоДанных = Данные.ДанныеОтправителя.Содержание;
	ФорматОтвета = ФорматыЭДО.ФорматОтветногоТитула(Данные.ДанныеОтправителя.Формат);
	
	Если ЭтоУПД(ФорматОтвета) Тогда
		
		Элементы.ГруппаУПД2019.Видимость = Истина;
		Элементы.ГруппаУКД2020.Видимость = Ложь;
		Элементы.ГруппаДокументОРасхождениях.Видимость = Ложь;
		
		ТаблицаТоваровЭД = ЭлектронноеВзаимодействие.ДанныеЭлементаДереваЭлектронногоДокумента(
			ДеревоДанных, "СведенияОТоварах");
		
		Для каждого Строка Из ТаблицаТоваровЭД Цикл
			СтрокаДенежныеОбязательства = ДенежныеОбязательства.Добавить();
			СтрокаДенежныеОбязательства.НомерСтрокиИнформацииПродавца = ТаблицаТоваровЭД.Индекс(Строка) + 1;	
		КонецЦикла;
		
		НомерГосКонтракта = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(
			ДеревоДанных, "ДополнительныеСведенияОбУчастниках.ЗакупкаДляГосударственныхНужд.НомерГосКонтракта");
		Если ЗначениеЗаполнено(НомерГосКонтракта) Тогда
			ЗакупкаДляГосударственныхНужд = Истина;	
		КонецЕсли;
		
		Элементы.ГруппаЗакупкаДляГосударственныхНужд.Видимость = ЗакупкаДляГосударственныхНужд;
		
		КодИтога = "1";
	
	Иначе
		
		Элементы.ГруппаУКД2020.Видимость = Истина;
		Элементы.ГруппаУПД2019.Видимость = Ложь;
		
		СодержаниеОперации_УКД = "С изменением стоимости согласен";	
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Элементы.ГруппаЗакупкаДляГосударственныхНужд.Видимость = Ложь;
	Элементы.ГруппаДокументОРасхождениях.Видимость = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СоставительДокументаНаименованиеПриИзменении(Элемент)
	
	Если СоставительДокумента <> Покупатель Тогда
		Элементы.СоставительДокументаДоверенность.Видимость = Истина;	
	Иначе
		Элементы.СоставительДокументаДоверенность.Видимость = Ложь;	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЕстьДокументОРасхожденияхПриИзменении(Элемент)
	
	ЕстьДокументОРасхожденияхПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЕстьДокументОРасхожденияхПриИзмененииНаСервере()
	
	Элементы.ГруппаДокументОРасхождениях.Видимость = ЕстьДокументОРасхождениях; 
	
	Если ЕстьДокументОРасхождениях Тогда
		КодИтога = "2";
		Элементы.ЕстьДокументОРасхождениях.ЦветТекстаЗаголовка = ЦветаСтиля.ЦветАкцента; 
	Иначе
		КодИтога = "1";
		Элементы.ЕстьДокументОРасхождениях.ЦветТекстаЗаголовка = ЦветаСтиля.ЦветТекстаФормы;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодИтогаПриИзменении(Элемент)
	
	Если КодИтога = "2" Тогда
		ЕстьДокументОРасхождениях = Истина;
		Элементы.ГруппаДокументОРасхождениях.Видимость = ЕстьДокументОРасхождениях;
	Иначе
		ЕстьДокументОРасхождениях = Ложь;
		Элементы.ГруппаДокументОРасхождениях.Видимость = ЕстьДокументОРасхождениях;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодписатьИОтправить(Команда)
	
	Если ЭтоУПД(ФорматОтвета) Тогда
		СтруктураОтвета = СформироватьСтруктуруОтвета_УПД2019_ИнформацияПокупателя();
	Иначе
		СтруктураОтвета = СформироватьСтруктуруОтвета_УКД2020_ИнформацияПокупателя();
	КонецЕсли;
	
	Если СтруктураОтвета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
    ПодписатьИОтправитьДокумент(СтруктураОтвета);
    
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭтоУПД(ФорматОтвета)
	
	Форматы = ЭлектронныеДокументыЭДО.ПоддерживаемыеФорматы();
	Если ФорматОтвета = Форматы.ФНС.УПД2019.ИнформацияПокупателя Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;	
КонецФункции

&НаКлиенте
Функция СформироватьСтруктуруОтвета_УКД2020_ИнформацияПокупателя()
	
	Если Не ПроверкаЗаполнения() Тогда
		Возврат Неопределено;	
	КонецЕсли;
	
	СтруктураОтвета_УКД2020_ИнформацияПокупателя = Новый Структура;
		
	СоставительДокументаНаименование = СоставительДокументаНаименование();
	СтруктураОтвета_УКД2020_ИнформацияПокупателя.Вставить("СоставительДокументаНаименование", 
		СоставительДокументаНаименование);
		
	Если СоставительДокумента <> Покупатель Тогда
		СтруктураОтвета_УКД2020_ИнформацияПокупателя.Вставить("СоставительДокументаДоверенность", 
			СоставительДокументаДоверенность);			
	КонецЕсли;
	
	СтруктураОтвета_УКД2020_ИнформацияПокупателя.Вставить("ДатаСогласования", ДатаСогласования);
	СтруктураОтвета_УКД2020_ИнформацияПокупателя.Вставить("СодержаниеОперации", СодержаниеОперации_УКД);
	
	Возврат СтруктураОтвета_УКД2020_ИнформацияПокупателя; 
КонецФункции

&НаКлиенте
Функция СформироватьСтруктуруОтвета_УПД2019_ИнформацияПокупателя()
	
	Если Не ПроверкаЗаполнения() Тогда
		Возврат Неопределено;	
	КонецЕсли;
		
	СтруктураОтвета_УПД2019_ИнформацияПокупателя = Новый Структура;
				
	СоставительДокументаНаименование = СоставительДокументаНаименование();			
	СтруктураОтвета_УПД2019_ИнформацияПокупателя.Вставить("СоставительДокументаНаименование", 
		СоставительДокументаНаименование);
		
	Если СоставительДокумента <> Покупатель Тогда
		СтруктураОтвета_УПД2019_ИнформацияПокупателя.Вставить("СоставительДокументаДоверенность", 
			СоставительДокументаДоверенность);			
	КонецЕсли;
	
	СведенияОПринятииТоваров = Новый Структура;
	СведенияОПринятииТоваров.Вставить("КодИтога", 									КодИтога);
	СведенияОПринятииТоваров.Вставить("ДатаПолученияТоваров", 						ДатаПолученияТоваров); 
	СведенияОПринятииТоваров.Вставить("СодержаниеОперации", 						СодержаниеОперации);
	
	СтруктураОтвета_УПД2019_ИнформацияПокупателя.Вставить("СведенияОПринятииТоваров" , СведенияОПринятииТоваров);
	
	Если ЕстьДокументОРасхождениях Тогда 
		
		ДокументОРасхождениях = Новый Структура;
		ДокументОРасхождениях.Вставить("Вид", 			ДокументОРасхожденияхВид);
		ДокументОРасхождениях.Вставить("Наименование", 	ДокументОРасхожденияхНаименование);
		ДокументОРасхождениях.Вставить("Дата", 			ДокументОРасхожденияхДата);
		ДокументОРасхождениях.Вставить("Номер", 		ДокументОРасхожденияхНомер); 
		
		СтруктураОтвета_УПД2019_ИнформацияПокупателя.Вставить("ДокументОРасхождениях" , ДокументОРасхождениях);
		
	КонецЕсли;
	
	Если ЗакупкаДляГосударственныхНужд Тогда
		
		ЗакупкаДляГосударственныхНуждСтруктура = Новый Структура;
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("КодЗакупки", 									КодЗакупки);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("НомерЛицевогоСчетаПокупателя", 				НомерЛицевогоСчетаПокупателя);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("НаименованиеФинансовогоОрганаПокупателя", 		НаименованиеФинансовогоОрганаПокупателя);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("НомерРеестровойЗаписиПокупателя", 				НомерРеестровойЗаписиПокупателя);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("НомерБюджетногоОбязательстваПокупателя", 		НомерБюджетногоОбязательстваПокупателя);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("КазначействоПокупателяКод", 					КазначействоПокупателяКод);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("КазначействоПокупателяНаименование", 			КазначействоПокупателяНаименование);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("ОКТМОМестаПоставки", 							ОКТМОМестаПоставки);   
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("НомерДенежногоОбязательства", 					НомерДенежногоОбязательства);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("ПредельнаяДатаОплаты", 						ПредельнаяДатаОплаты);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("ОКТМОПокупателя", 								ОКТМОПокупателя);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("НомерРеестровойЗаписиПокупателя", 				НомерРеестровойЗаписиПокупателя);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("НомерБюджетногоОбязательстваПокупателя", 		КодЗакупки);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("КазначействоПокупателяКод", 					КазначействоПокупателяКод);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("КазначействоПокупателяНаименование", 			КазначействоПокупателяНаименование);
		ЗакупкаДляГосударственныхНуждСтруктура.Вставить("ОКТМОМестаПоставки", 							ОКТМОМестаПоставки);
		
		СтруктураОтвета_УПД2019_ИнформацияПокупателя.Вставить("ЗакупкаДляГосударственныхНужд" , ЗакупкаДляГосударственныхНуждСтруктура);
	
		МассивДенежныхОбязательств = ПоместитьТаблицуДенежныеОбязательстваВМассив();
		СтруктураОтвета_УПД2019_ИнформацияПокупателя.Вставить("ДенежныеОбязательства" , МассивДенежныхОбязательств);
					
	КонецЕсли; 
	
	Возврат СтруктураОтвета_УПД2019_ИнформацияПокупателя; 	 		
КонецФункции

&НаСервере
Функция ПоместитьТаблицуДенежныеОбязательстваВМассив()	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ДенежныеОбязательства.Выгрузить());	
КонецФункции

&НаСервере
Функция СоставительДокументаНаименование()
	
	СведенияОПокупателе = ЭлектронноеВзаимодействие.СтруктураДанныхЮрФизЛица();
	ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьДанныеЮрФизЛица(СоставительДокумента, СведенияОПокупателе);	
	НаименованиеСоставителяДокумента = СведенияОПокупателе.ПолноеНаименование + ?(ЗначениеЗаполнено(
		СведенияОПокупателе.КПП), СтрШаблон(НСтр("ru = ', ИНН/КПП %1/%2'"), СведенияОПокупателе.ИНН,
		СведенияОПокупателе.КПП), СтрШаблон(НСтр("ru = ', ИНН %1'"), СведенияОПокупателе.ИНН));
		
	Возврат НаименованиеСоставителяДокумента;		
КонецФункции

&НаКлиенте
Функция ПроверкаЗаполнения()
	
	СписокОшибок.Очистить();
	
	Если ЭтоУПД(ФорматОтвета) Тогда		
		ПроверкаЗаполненияУПД2019();		
	Иначе
		ПроверкаЗаполненияУКД2020();		
	КонецЕсли;
	
	Если СписокОшибок.Количество() > 0 Тогда
		Для Каждого Ошибка Из СписокОшибок Цикл
			ОбщегоНазначенияКлиент.СообщитьПользователю(Ошибка.Значение, ,
			Ошибка.Представление);	
		КонецЦикла;
		
		Возврат Ложь;
	Иначе
		Возврат Истина;	
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПроверкаЗаполненияУПД2019()
	
	Если Не ЗначениеЗаполнено(КодИтога) Тогда
			СписокОшибок.Добавить(Элементы.КодИтога.Заголовок 
				+ ": значение не заполнено", Элементы.КодИтога.Имя);	
	КонецЕсли;
	
	Если СоставительДокумента <> Покупатель Тогда
		Если Не ЗначениеЗаполнено(СоставительДокументаДоверенность) Тогда
			СписокОшибок.Добавить(Элементы.СоставительДокументаДоверенность.Заголовок 
				+ ": значение не заполнено", Элементы.СоставительДокументаДоверенность.Имя);	
		КонецЕсли;		
	КонецЕсли;
	
	Если ЗакупкаДляГосударственныхНужд Тогда
		ПроверкаЗаполненияГруппы(Элементы.ГруппаЗакупкаДляГосударственныхНужд);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПроверкаЗаполненияУКД2020()
	
	Если Не ЗначениеЗаполнено(ДатаСогласования) Тогда
			СписокОшибок.Добавить(Элементы.ДатаСогласования.Заголовок 
				+ ": значение не заполнено", Элементы.ДатаСогласования.Имя);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СодержаниеОперации_УКД) Тогда
		СписокОшибок.Добавить(Элементы.СодержаниеОперации_УКД.Заголовок 
			+ ": значение не заполнено", Элементы.СодержаниеОперации_УКД.Имя);
	КонецЕсли;
		
	Если СоставительДокумента <> Покупатель Тогда
		Если Не ЗначениеЗаполнено(СоставительДокументаДоверенность) Тогда
			СписокОшибок.Добавить(Элементы.СоставительДокументаДоверенность.Заголовок 
				+ ": значение не заполнено", Элементы.СоставительДокументаДоверенность.Имя);	
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаЗаполненияГруппы(ГруппаФормы)
			
	НеобязательныеРеквизиты = Новый Массив;
	НеобязательныеРеквизиты.Добавить("КодЗакупки");
	НеобязательныеРеквизиты.Добавить("НомерБюджетногоОбязательстваПокупателя");
	НеобязательныеРеквизиты.Добавить("ОКТМОМестаПоставки");
	НеобязательныеРеквизиты.Добавить("ПредельнаяДатаОплаты");
	НеобязательныеРеквизиты.Добавить("НомерДенежногоОбязательства");
	НеобязательныеРеквизиты.Добавить("ОчередностьПлатежа");
	НеобязательныеРеквизиты.Добавить("ВидПлатежа");
	
	Для Каждого ЭлементГруппы Из ГруппаФормы.ПодчиненныеЭлементы Цикл
		Если ТипЗнч(ЭлементГруппы) = Тип("ГруппаФормы") Тогда 
			Если ЗначениеЗаполнено(ЭлементГруппы.ПодчиненныеЭлементы) Тогда
				ПроверкаЗаполненияГруппы(ЭлементГруппы);
			КонецЕсли;
		Иначе
			Если НеобязательныеРеквизиты.Найти(ЭлементГруппы.Имя) = Неопределено Тогда
				Если Не ЗначениеЗаполнено(ЭтотОбъект[ЭлементГруппы.Имя]) Тогда 
				СписокОшибок.Добавить(ЭлементГруппы.Заголовок + ": значение не заполнено", ЭлементГруппы.Имя);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьИОтправитьДокумент(СтруктураОтвета)
	
	МассивЭлектронныхДокументов = Новый Массив;
	МассивЭлектронныхДокументов.Добавить(ЭлектронныйДокумент);
	ОбъектыДействий = Новый Структура;
	ОбъектыДействий.Вставить("ЭлектронныеДокументы", МассивЭлектронныхДокументов);
	
	НаборДействий = Новый Соответствие;	
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.Утвердить"));
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.СформироватьОтвет"));
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.Подписать"));
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.ПодготовитьКОтправке"));
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.Отправить"));
		
	Оповещение = Новый ОписаниеОповещения("ПослеВыполненияДействийПоЭДО", ЭтотОбъект);
	
	ПараметрыВыполненияДействийПоЭДО = ЭлектронныеДокументыЭДОКлиентСервер.НовыеПараметрыВыполненияДействийПоЭДО();
	ПараметрыВыполненияДействийПоЭДО.НаборДействий = НаборДействий;
	ПараметрыВыполненияДействийПоЭДО.ОбъектыДействий.ЭлектронныеДокументы = ОбъектыДействий.ЭлектронныеДокументы;
	ПараметрыВыполненияДействийПоЭДО.Вставить("ДанныеРучногоФормированияОтветногоТитула", СтруктураОтвета); 
	
	ЭлектронныеДокументыЭДОКлиент.НачатьВыполнениеДействийПоЭДО(Оповещение, ПараметрыВыполненияДействийПоЭДО);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПослеВыполненияДействийПоЭДО(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда 
		
		Если Результат.Свойство("ОшибкиФормирования") И Результат.ОшибкиФормирования.Количество() Тогда		
			
			Для Каждого Ошибка Из Результат.ОшибкиФормирования[0].ОшибкиДанных.ЗаполнениеДанных Цикл
				ОбщегоНазначенияКлиент.СообщитьПользователю(Ошибка.ТекстОшибки);	
			КонецЦикла;
			
		ИначеЕсли Результат.Свойство("КонтекстДиагностики")
			И ОбработкаНеисправностейБЭДКлиентСервер.ЕстьОшибки(Результат.КонтекстДиагностики) Тогда
			
			ОбработкаНеисправностейБЭДКлиент.ОбработатьОшибки(Результат.КонтекстДиагностики);		
		Иначе
			Оповестить(ИнтерфейсДокументовЭДОКлиент.ИмяСобытияОбновленияТекущихДелЭДО());
			Оповестить("УдалитьИзСпискаДокументовДляФормированияОтветногоТитула");
			Оповестить("ОбновитьСостояниеЭД");
			
			Если Открыта() Тогда
				Закрыть(Истина);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти
