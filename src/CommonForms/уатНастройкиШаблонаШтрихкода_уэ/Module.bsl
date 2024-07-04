
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПравоДоступа("Изменение", Метаданные.Константы.уатШаблонТрекНомера) Тогда
		ТолькоПросмотр = Истина;
		Элементы.ФормаСохранитьШаблон.Видимость = Ложь;
		Элементы.ДоступныеПараметры.Доступность = Ложь;
		Элементы.ТекстШаблона.Доступность	    = Ложь;
	КонецЕсли;
	
	ЗаполнитьСписокПолей();
	уатНастройкиШаблонов.ФормаНастройкиШаблонаШтрихКода_ЗаполнитьТекстШаблона(ЭтотОбъект);
	
КонецПроцедуры  

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СформироватьПример();
КонецПроцедуры 

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Модифицированность Тогда  
		Отказ = Истина;
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ПередЗакрытиемПродолжение", ЭтотОбъект);
		ПоказатьВопрос(ОповещениеОЗавершении, "Данные настроек изменены. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы 

&НаКлиенте
Процедура СохранитьШаблон(Команда)	
	ЗаписатьНастройкиШаблона();	
	Закрыть();	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВнутреннийШаблон(Команда)
	ЗаполнитьПоляШаблонаВнутреннегоОтправления();
	ОбновитьТекстШаблона();
	СформироватьПример();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМеждународныйШаблон(Команда)
	ЗаполнитьПоляШаблонаМеждународногоОтправления();
	ОбновитьТекстШаблона();
	ТекстШаблона = НСтр("ru='RA; ';en='RA; '") + ТекстШаблона;
	СформироватьПример();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДоступныеПараметрыПриИзменении(Элемент)
	ОбновитьТекстШаблона(); 
	СформироватьПример();
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПараметрыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ЗаполнитьСписокРеквизитовОбъекта();
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПараметрыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ОбновитьТекстШаблона();
	СформироватьПример();
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПараметрыПослеУдаления(Элемент)
	ОбновитьТекстШаблона();
	СформироватьПример();
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПараметрыПолеРегистраПриИзменении(Элемент)
	ЗаполнитьПолеДетализацииПоПредставлению();
	ЗаполнитьСписокРеквизитовОбъекта();
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПараметрыРеквизитПриИзменении(Элемент)
	ЗаполнитьРеквизитПоПредставлению();
	ОбновитьТекстШаблона();
	СформироватьПример();
	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПараметрыРеквизитОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ТекСтрока = Элементы.ДоступныеПараметры.ТекущиеДанные;
	ТекСтрока.РеквизитПредставление = "";
	
	ЗаполнитьРеквизитПоПредставлению();
	ОбновитьТекстШаблона(); 
	СформироватьПример();
	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОбновитьНажатие(Элемент)
	СформироватьПример();
КонецПроцедуры  

&НаКлиенте
Процедура ТекстШаблонаПриИзменении(Элемент)
	СформироватьПример();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

&НаКлиенте 
Процедура ПередЗакрытиемПродолжение(Результат, ДопПараметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьНастройкиШаблона();
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда 
		Модифицированность = Ложь;
		Закрыть();
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекстШаблона()
	ТекстШаблона = "";
	Для Каждого ТекСтрока Из ДоступныеПараметры Цикл
		ТекстШаблона = ТекстШаблона + "[" + ТекСтрока.ПолеРегистра;
		Если НЕ ПустаяСтрока(ТекСтрока.Реквизит) Тогда
			ТекстШаблона = ТекстШаблона + "." + ТекСтрока.Реквизит;
		КонецЕсли;
		ТекстШаблона = ТекстШаблона + "]; ";
	КонецЦикла;
	Если НЕ ПустаяСтрока(ТекстШаблона) Тогда
		ТекстШаблона = Лев(ТекстШаблона, СтрДлина(ТекстШаблона)-2);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПолей()
	
	ПредставленияПолей = Новый СписокЗначений;
	
	ТекИмя           = "Заказ";
	ТекПредставление = НСтр("ru='Заказ на ТС';en='Order for trucking'");
	ТекКартинка      = БиблиотекаКартинок.Документ;	
	ПредставленияПолей.Добавить(ТекИмя, ТекПредставление,, ТекКартинка);
	
	ТекИмя           = "ПочтовыйИндексПунктаОтправления";
	ТекПредставление = НСтр("ru='Почтовый индекс пункта отправления';en='Postal code of origin'");
	ТекКартинка      = БиблиотекаКартинок.Реквизит;	
	ПредставленияПолей.Добавить(ТекИмя, ТекПредставление,, ТекКартинка);
	
	ТекИмя           = "ПочтовыйИндексПунктаПрибытия";
	ТекПредставление = НСтр("ru='Почтовый индекс пункта прибытия';en='Postal code of destination'");
	ТекКартинка      = БиблиотекаКартинок.Реквизит;	
	ПредставленияПолей.Добавить(ТекИмя, ТекПредставление,, ТекКартинка);
	
	ТекИмя           = "КодСтраныОтправления";
	ТекПредставление = НСтр("ru='Код страны пункта отправления';en='Origin country code'");
	ТекКартинка      = БиблиотекаКартинок.Реквизит;	
	ПредставленияПолей.Добавить(ТекИмя, ТекПредставление,, ТекКартинка);
	
	ТекИмя           = "КодСтраныНазначения";
	ТекПредставление = НСтр("ru='Код страны пункта назначения';en='Destination country code'");
	ТекКартинка      = БиблиотекаКартинок.Реквизит;	
	ПредставленияПолей.Добавить(ТекИмя, ТекПредставление,, ТекКартинка);
	
	ТекИмя           = "ПорядковыйНомерМесяца";
	ТекПредставление = НСтр("ru='Порядковый номер месяца';en=''");
	ТекКартинка      = БиблиотекаКартинок.Реквизит;	
	ПредставленияПолей.Добавить(ТекИмя, ТекПредставление,, ТекКартинка);
	
	ТекИмя           = "УникальныйНомерОтправления";
	ТекПредставление = НСтр("ru='Уникальный номер отправления';en='Unique departure number'");
	ТекКартинка      = БиблиотекаКартинок.Реквизит;	
	ПредставленияПолей.Добавить(ТекИмя, ТекПредставление,, ТекКартинка); 
	
	ТекИмя           = "ПорядковыйНомерГруза";
	ТекПредставление = НСтр("ru='Порядковый номер груза';en='Ordinal number of cargo'");
	ТекКартинка      = БиблиотекаКартинок.Реквизит;	
	ПредставленияПолей.Добавить(ТекИмя, ТекПредставление,, ТекКартинка);
	
	ТекИмя           = "КонтрольнаяЦифраВнутренняя";
	ТекПредставление = НСтр("ru='Контрольная цифра (внутрироссийское отправление)';en=''");
	ТекКартинка      = БиблиотекаКартинок.Реквизит;	
	ПредставленияПолей.Добавить(ТекИмя, ТекПредставление,, ТекКартинка);
	
	ТекИмя           = "КонтрольнаяЦифраМеждународная";
	ТекПредставление = НСтр("ru='Контрольная цифра (международное отправление)';en=''");
	ТекКартинка      = БиблиотекаКартинок.Реквизит;	
	ПредставленияПолей.Добавить(ТекИмя, ТекПредставление,, ТекКартинка);
	
	ТекИмя           = "КонтрольнаяЦифраУниверсальная";
	ТекПредставление = НСтр("ru='Контрольная цифра (универсальная)';en=''");
	ТекКартинка      = БиблиотекаКартинок.Реквизит;	
	ПредставленияПолей.Добавить(ТекИмя, ТекПредставление,, ТекКартинка);
	
	Элементы.ДоступныеПараметрыПолеРегистра.СписокВыбора.Очистить();
	Для Каждого ТекПредставление Из ПредставленияПолей Цикл
		Элементы.ДоступныеПараметрыПолеРегистра.СписокВыбора.Добавить(ТекПредставление.Представление,,,
			ТекПредставление.Картинка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПолеДетализацииПоПредставлению()
	ТекСтрока = Элементы.ДоступныеПараметры.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
			
	Для Каждого ТекЭлем Из ПредставленияПолей Цикл
		Если ТекЭлем.Представление = ТекСтрока.ПолеПредставление Тогда
			ТекСтрока.ПолеРегистра = ТекЭлем.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокРеквизитовОбъекта()
	ТекСтрока = Элементы.ДоступныеПараметры.ТекущиеДанные;

	ДанныеВыбора = СписокРеквизитовОбъекта(ТекСтрока.ПолеРегистра);
	Элементы.ДоступныеПараметрыРеквизит.СписокВыбора.ЗагрузитьЗначения(ДанныеВыбора.ВыгрузитьЗначения());
	
	Если Элементы.ДоступныеПараметрыРеквизит.СписокВыбора.НайтиПоЗначению(ТекСтрока.РеквизитПредставление) = Неопределено Тогда
		ТекСтрока.Реквизит = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СписокРеквизитовОбъекта(Поле)
	СписокВыбора = Новый СписокЗначений;
	ПредставленияРеквизитов = Новый СписокЗначений;
	
	Если Поле = "Заказ" Тогда
		
		
		СписокДокументов = Новый СписокЗначений;
		СписокДокументов.Добавить("уатЗаказГрузоотправителя");
		
		
		Для Каждого ТекВидДокумента Из СписокДокументов Цикл
			Если СписокВыбора.НайтиПоЗначению("Номер") = Неопределено Тогда
				СписокВыбора.Добавить("Номер");
				ПредставленияРеквизитов.Добавить("Номер", "Номер");
			КонецЕсли;
			Если СписокВыбора.НайтиПоЗначению("Дата") = Неопределено Тогда
				СписокВыбора.Добавить("Дата");
				ПредставленияРеквизитов.Добавить("Дата", "Дата");
			КонецЕсли;
			
			Для Каждого ТекРеквизит Из Метаданные.Документы[ТекВидДокумента.Значение].Реквизиты Цикл
				Если Лев(ТекРеквизит.Имя, СтрДлина("Удалить")) = "Удалить" Тогда
					Продолжить;
				КонецЕсли;
				Если СписокВыбора.НайтиПоЗначению(ТекРеквизит.Синоним) = Неопределено Тогда
					СписокВыбора.Добавить(ТекРеквизит.Синоним);
					ПредставленияРеквизитов.Добавить(ТекРеквизит.Имя, ТекРеквизит.Синоним);
				КонецЕсли;
			КонецЦикла;
			
			мсвДопРеквизиты = УправлениеСвойствами.СвойстваОбъекта(Документы[ТекВидДокумента.Значение].ПустаяСсылка());
			Для Каждого ТекРеквизит Из мсвДопРеквизиты Цикл
				ТекПредставление = ТекРеквизит.Наименование + " (доп.)";
				Если СписокВыбора.НайтиПоЗначению(ТекПредставление) = Неопределено Тогда
					СписокВыбора.Добавить(ТекПредставление);
					ПредставленияРеквизитов.Добавить(ТекРеквизит.ИдентификаторДляФормул, ТекПредставление);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
	СписокВыбора.СортироватьПоЗначению();
	
	Возврат СписокВыбора;
КонецФункции

&НаКлиенте
Процедура ЗаполнитьРеквизитПоПредставлению()
	ТекСтрока = Элементы.ДоступныеПараметры.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ТекСтрока.РеквизитПредставление) Тогда
		ТекСтрока.Реквизит = "";
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекЭлем Из ПредставленияРеквизитов Цикл
		Если ТекЭлем.Представление = ТекСтрока.РеквизитПредставление Тогда
			ТекСтрока.Реквизит = ТекЭлем.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоляШаблонаВнутреннегоОтправления()

	ДоступныеПараметры.Очистить();
	
	НовСтрока = ДоступныеПараметры.Добавить();
	НовСтрока.ПолеРегистра      = "ПочтовыйИндексПунктаОтправления";
	НовСтрока.ПолеПредставление = "Почтовый индекс пункта отправления";
	
	НовСтрока = ДоступныеПараметры.Добавить();
	НовСтрока.ПолеРегистра      = "ПорядковыйНомерМесяца";
	НовСтрока.ПолеПредставление = "Порядковый номер месяца";
	
	НовСтрока = ДоступныеПараметры.Добавить();
	НовСтрока.ПолеРегистра      = "УникальныйНомерОтправления";
	НовСтрока.ПолеПредставление = "Уникальный номер отправления";  
	
	ДлинаУникальногоНомера = 5;
	
	НовСтрока = ДоступныеПараметры.Добавить();
	НовСтрока.ПолеРегистра      = "КонтрольнаяЦифраВнутренняя";
	НовСтрока.ПолеПредставление = "Контрольная цифра (внутрироссийское отправление)";

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоляШаблонаМеждународногоОтправления()
	
	ДоступныеПараметры.Очистить();
	
	НовСтрока = ДоступныеПараметры.Добавить();
	НовСтрока.ПолеРегистра      = "УникальныйНомерОтправления";
	НовСтрока.ПолеПредставление = "Уникальный номер отправления"; 
	
	ДлинаУникальногоНомера = 8;
	
	НовСтрока = ДоступныеПараметры.Добавить();
	НовСтрока.ПолеРегистра      = "КонтрольнаяЦифраМеждународная";
	НовСтрока.ПолеПредставление = "Контрольная цифра (международное отправление)";
	
	НовСтрока = ДоступныеПараметры.Добавить();
	НовСтрока.ПолеРегистра      = "КодСтраныОтправления";
	НовСтрока.ПолеПредставление = "Код страны пункта отправления";
		
КонецПроцедуры

&НаСервере
Функция ПолучитьДемоОбъект() 
	
	ТипШК = Константы.уатТипШтрихкодаДляПечати_уэ.Получить();
	
	Запрос = Новый Запрос();  
	
	// Пусть демо-объектом для примера будет последний созданный, проведенный и не помеченный на удаление
	// Заказ на ТС в базе. Иначе будет программно созданный демо-объект только с виртуальными полями.
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	уатЗаказГрузоотправителя.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.уатЗаказГрузоотправителя КАК уатЗаказГрузоотправителя
	|ГДЕ
	|	уатЗаказГрузоотправителя.Проведен
	|	И НЕ уатЗаказГрузоотправителя.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	уатЗаказГрузоотправителя.Дата УБЫВ";  
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда  
		
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			СсылкаНаДемоОбъект = Выборка.Ссылка;
		КонецЕсли;  
		
		НастройкиШаблона = Новый Структура("ТекстШаблона, ДлинаУникальногоНомера", ТекстШаблона, ДлинаУникальногоНомера);
		
		ЗаполненныйШаблон = уатНастройкиШаблонов.ПодставитьПараметрыВШаблонШК(НастройкиШаблона, СсылкаНаДемоОбъект); 
		Если ТипШК = Перечисления.уатТипыШтрихкодов.GS1_128 Тогда
			ДемоОбъект = уатЗащищенныеФункцииСервер_проф.ШтрихкодGS1(СсылкаНаДемоОбъект, 0, 0,,, ЗаполненныйШаблон);
		Иначе
			ДемоОбъект = ЗаполненныйШаблон;
		КонецЕсли;
		
	Иначе
		
		ДемоОбъект = Новый Структура();
		ДемоОбъект.Вставить("ПочтовыйИндексПунктаОтправления", "142117");
		ДемоОбъект.Вставить("ПочтовыйИндексПунктаПрибытия",    "214032");
		ДемоОбъект.Вставить("КодСтраныОтправления", НСтр("ru = 'RU';en='RU'"));
		ДемоОбъект.Вставить("КодСтраныНазначения",  НСтр("ru = 'CN';en='CN'"));
		ДемоОбъект.Вставить("УникальныйНомерОтправления", "41034224");
		ДемоОбъект.Вставить("ПорядковыйНомерМесяца",      "71");
		ДемоОбъект.Вставить("ПорядковыйНомерГруза",       "3");
		ДемоОбъект.Вставить("КонтрольнаяЦифраВнутренняя", уатНастройкиШаблонов.КонтрольнаяЦифраОтправления("41034224", "Внутренняя"));
		ДемоОбъект.Вставить("КонтрольнаяЦифраМеждународная", уатНастройкиШаблонов.КонтрольнаяЦифраОтправления("41034224", "Международная"));
		ДемоОбъект.Вставить("КонтрольнаяЦифраУниверсальная", уатНастройкиШаблонов.КонтрольнаяЦифраОтправления("41034224", "Универсальная"));
		
	КонецЕсли;
	
	Возврат ДемоОбъект;
	
КонецФункции

&НаКлиенте
Функция ПодставитьПараметрыВДемоНомер(ДанныеОбъекта)  
	
	Если ТипЗнч(ДанныеОбъекта) = Тип("Структура") Тогда
		
		Результат = ТекстШаблона;
		
		Результат = СтрЗаменить(Результат,"[ПочтовыйИндексПунктаОтправления]", ДанныеОбъекта.ПочтовыйИндексПунктаОтправления);
		Результат = СтрЗаменить(Результат,"[ПочтовыйИндексПунктаПрибытия]",ДанныеОбъекта.ПочтовыйИндексПунктаПрибытия);
		Результат = СтрЗаменить(Результат,"[КодСтраныОтправления]",ДанныеОбъекта.КодСтраныОтправления);
		Результат = СтрЗаменить(Результат,"[КодСтраныНазначения]",ДанныеОбъекта.КодСтраныНазначения);
		Результат = СтрЗаменить(Результат,"[ПорядковыйНомерМесяца]",ДанныеОбъекта.ПорядковыйНомерМесяца); 
		Результат = СтрЗаменить(Результат,"[УникальныйНомерОтправления]", ДанныеОбъекта.УникальныйНомерОтправления);
		Результат = СтрЗаменить(Результат,"[КонтрольнаяЦифраВнутренняя]", ДанныеОбъекта.КонтрольнаяЦифраВнутренняя);
		Результат = СтрЗаменить(Результат,"[КонтрольнаяЦифраМеждународная]", ДанныеОбъекта.КонтрольнаяЦифраМеждународная);
		Результат = СтрЗаменить(Результат,"[ПорядковыйНомерГруза]", ДанныеОбъекта.ПорядковыйНомерГруза);
		Результат = СтрЗаменить(Результат, ";", "");
		Результат = СтрЗаменить(Результат, " ", "");
		Результат = СтрЗаменить(Результат,"[КонтрольнаяЦифраУниверсальная]", ДанныеОбъекта.КонтрольнаяЦифраУниверсальная);
		
		Возврат Результат;  
		
	ИначеЕсли ТипЗнч(ДанныеОбъекта) = Тип("Строка") Тогда
		Возврат ДанныеОбъекта;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СформироватьПример()
	
	Пример = ПодставитьПараметрыВДемоНомер(ПолучитьДемоОбъект());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройкиШаблона() 
	
	Если Модифицированность Тогда
		
		НастройкиШаблона = Новый Структура();
		НастройкиШаблона.Вставить("ТекстШаблона", ТекстШаблона);
		НастройкиШаблона.Вставить("ДлинаУникальногоНомера", ДлинаУникальногоНомера);
		
		МассивПараметров = Новый Массив();
		Для Каждого ТекСтрока Из ДоступныеПараметры Цикл
			
			СтруктураСтроки = Новый Структура();
			СтруктураСтроки.Вставить("ПолеРегистра", ТекСтрока.ПолеРегистра);
			СтруктураСтроки.Вставить("ПолеПредставление", ТекСтрока.ПолеПредставление);
			СтруктураСтроки.Вставить("Реквизит", ТекСтрока.Реквизит);
			СтруктураСтроки.Вставить("РеквизитПредставление", ТекСтрока.РеквизитПредставление);
			МассивПараметров.Добавить(СтруктураСтроки);
			
		КонецЦикла;
		
		НастройкиШаблона.Вставить("МассивПараметров", МассивПараметров);
		
		уатНастройкиШаблонов.ЗаписатьШаблонТрекНомера(НастройкиШаблона);
		Модифицированность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
