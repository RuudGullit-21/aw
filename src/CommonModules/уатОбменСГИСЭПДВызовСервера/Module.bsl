
#Область СлужебныйПрограммныйИнтерфейс

Функция ДанныеЗаполненияЭТрН(Основание) Экспорт
	ДанныеЗаполнения = Новый Структура;
	
	Если НЕ ЗначениеЗаполнено(Основание) 
		ИЛИ ТипЗнч(Основание) <> Тип("ДокументСсылка.уатРеализацияУслуг") Тогда
		
		Возврат ДанныеЗаполнения;
	КонецЕсли; 
	
	СписокРеквизитов = "Организация, Контрагент, Грузоотправитель, Грузополучатель, 
		|Перевозчик, Дата, Номер, АдресДоставки, 
		|Организация, ЭтоУниверсальныйДокумент";
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Основание, СписокРеквизитов);
		
	ДанныеЗаполнения.Вставить("ДокументыОснования", Новый Массив);
	ДанныеЗаполнения.ДокументыОснования.Добавить(Новый Структура("ДокументОснование", Основание));
		
	ДанныеЗаполнения.Вставить("Организация", РеквизитыОснования.Организация);
	
	
	ДанныеЗаполнения.Вставить("ТитулГрузоотправителяЗаказДата", РеквизитыОснования.Дата);
	
	ДанныеЗаполнения.Вставить("СсылкаТитулГрузоотправителяГрузоотправитель", ?(ЗначениеЗаполнено(РеквизитыОснования.Грузоотправитель), 
		РеквизитыОснования.Грузоотправитель, РеквизитыОснования.Организация));
	
	ДанныеЗаполнения.Вставить("СсылкаТитулГрузоотправителяГрузополучатель", ?(ЗначениеЗаполнено(РеквизитыОснования.Грузополучатель), 
		РеквизитыОснования.Грузополучатель, РеквизитыОснования.Контрагент));
		
	ДанныеЗаполнения.Вставить("СсылкаТитулГрузоотправителяПеревозчик", РеквизитыОснования.Перевозчик);
	
	ОбменСГИСЭПДКлиентСервер.ЗаполнитьРеквизитыУчастника(
		ДанныеЗаполнения.СсылкаТитулГрузоотправителяГрузоотправитель, "ТитулГрузоотправителяГрузоотправитель", ДанныеЗаполнения);
		
	ОбменСГИСЭПДКлиентСервер.ЗаполнитьРеквизитыУчастника(
		ДанныеЗаполнения.СсылкаТитулГрузоотправителяГрузополучатель, "ТитулГрузоотправителяГрузополучатель", ДанныеЗаполнения);
		
	ОбменСГИСЭПДКлиентСервер.ЗаполнитьРеквизитыУчастника(
		ДанныеЗаполнения.СсылкаТитулГрузоотправителяПеревозчик, "ТитулГрузоотправителяПеревозчик", ДанныеЗаполнения);
	
	ДанныеЗаполненияАдрес(ДанныеЗаполнения, РеквизитыОснования.АдресДоставки, "ТитулГрузоотправителяГрузополучательАдресДоставки");
		
	Возврат ДанныеЗаполнения;

КонецФункции

Функция ДанныеЗаполненияАдрес(ДанныеЗаполнения, Адрес, Префикс)
	
	Если НЕ ЗначениеЗаполнено(Адрес) Тогда
		Возврат ДанныеЗаполнения;
	КонецЕсли; 

	СтруктураАдреса = РаботаСАдресами.СведенияОбАдресе(Адрес);
	
	Если СтруктураАдреса.ТипАдреса = "ВСвободнойФорме" Тогда
		ДанныеЗаполнения.Вставить(Префикс + "Представление",   СтруктураАдреса.Представление);
		ДанныеЗаполнения.Вставить(Префикс + "КодСтраны",       СтруктураАдреса.КодСтраны);
	Иначе	
		ДанныеЗаполнения.Вставить(Префикс + "Индекс",          СтруктураАдреса.Индекс);
		ДанныеЗаполнения.Вставить(Префикс + "КодРегиона",      СтруктураАдреса.КодРегиона);
		ДанныеЗаполнения.Вставить(Префикс + "Город",           СтруктураАдреса.Город 
			+ ?(СтруктураАдреса.ГородТипКраткий = "", "", " ") + СтруктураАдреса.ГородТипКраткий); 
		ДанныеЗаполнения.Вставить(Префикс + "Район",           СтруктураАдреса.Район 
			+ ?(СтруктураАдреса.РайонТипКраткий = "", "", " ") + СтруктураАдреса.РайонТипКраткий);
		ДанныеЗаполнения.Вставить(Префикс + "НаселенныйПункт", СтруктураАдреса.НаселенныйПункт 
			+ ?(СтруктураАдреса.НаселенныйПунктТипКраткий = "", "", " ") + СтруктураАдреса.НаселенныйПунктТипКраткий);
		ДанныеЗаполнения.Вставить(Префикс + "Улица",           СтруктураАдреса.Улица 
			+ ?(СтруктураАдреса.УлицаТипКраткий = "", "", " ") + СтруктураАдреса.УлицаТипКраткий);
		ДанныеЗаполнения.Вставить(Префикс + "Дом",             СтруктураАдреса.Здание.Номер);
		Если СтруктураАдреса.Корпуса.Количество() > 0 Тогда
			ДанныеЗаполнения.Вставить(Префикс + "Корпус",      СтруктураАдреса.Корпуса[0].Номер);
		КонецЕсли;
	КонецЕсли;

	Возврат ДанныеЗаполнения;
КонецФункции

#КонецОбласти